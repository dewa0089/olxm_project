import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olxm_project/model/data.dart';
import 'package:olxm_project/screen/detail_screen.dart';
import 'package:olxm_project/services/data_services.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olxm_project/services/location_service.dart';

class PostingScreen extends StatefulWidget {
  final Data? data;

  const PostingScreen({super.key, this.data});

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  LatLng? _selectedLocation;
  File? _imageFile;
  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _nameController.text = widget.data!.product;
      _hargaController.text = currencyFormatter.format(widget.data!.harga);
      _nomorController.text = widget.data!.nomor;
      _selectedCategory = widget.data!.category;
      _addressController.text = widget.data!.address;
      _descriptionController.text = widget.data!.description;
      _selectedLocation =
          widget.data!.latitude != null && widget.data!.longitude != null
              ? LatLng(widget.data!.latitude!, widget.data!.longitude!)
              : null;
    } else {
      // Initialize harga to 0 when first opened
      _hargaController.text = currencyFormatter.format(0);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickLocation() async {
    try {
      final currentPosition = await LocationService.getCurrentPosition();
      if (currentPosition != null) {
        setState(() {
          _selectedLocation =
              LatLng(currentPosition.latitude, currentPosition.longitude);
        });
      } else {
        // Handle the case when currentPosition is null
        // For example, show an error message to the user
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to get current location.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle the error, for example, show an error message to the user
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred while getting the location: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  double? parseHarga(String harga) {
    try {
      // Remove currency symbol and formatting before parsing
      String cleanedHarga = harga.replaceAll('Rp. ', '').replaceAll('.', '');
      return double.parse(cleanedHarga);
    } catch (e) {
      // ignore: avoid_print
      print('Error parsing harga: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product Offers'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _imageFile != null
                              ? Image.file(_imageFile!,
                                  fit: BoxFit.cover, width: double.infinity)
                              : (widget.data?.imageUrl != null
                                  ? Image.network(widget.data!.imageUrl!,
                                      fit: BoxFit.cover, width: double.infinity)
                                  : Container()),
                        ),
                        Opacity(
                          opacity: _imageFile != null ? 0.0 : 1.0,
                          child: Center(
                            child: TextButton(
                              onPressed: _pickImage,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black54,
                              ),
                              child: const Text('Pilih Gambar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Product Name'),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                const Text('Harga'),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    // Format input as user types
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) {
                        final text = newValue.text;
                        if (text.isEmpty) return newValue;
                        final value = int.parse(text.replaceAll('.', ''));
                        final formattedValue = currencyFormatter.format(value);
                        return newValue.copyWith(
                          text: formattedValue,
                          selection: TextSelection.collapsed(
                              offset: formattedValue.length),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('WhatsApp Number'),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: _nomorController,
                  keyboardType: TextInputType
                      .phone, // Tipe keyboard untuk input nomor telepon
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly // Hanya menerima digit
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Category'),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Address'),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: _addressController,
                ),
                const SizedBox(height: 16),
                const Text('Description'),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: _descriptionController,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: _pickLocation,
                        style: ElevatedButton.styleFrom(
                            minimumSize:
                                const Size(400, 50), // Ukuran minimum tombol
                            backgroundColor: Colors.blue),
                        child: const Text('Ambil Lokasi Saya'),
                      ),
                    ],
                  ),
                ),
                const Text('Lokasi'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200, // Sesuaikan tinggi sesuai kebutuhan
                    child: _selectedLocation != null
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(_selectedLocation!.latitude,
                                  _selectedLocation!.longitude),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('selectedLocation'),
                                position: LatLng(_selectedLocation!.latitude,
                                    _selectedLocation!.longitude),
                              ),
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: const Text('Lokasi belum dipilih'),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String? imageUrl;
                      if (_imageFile != null) {
                        imageUrl =
                            await DataServices.uploadImage(_imageFile, null);
                      } else {
                        imageUrl = widget.data?.imageUrl;
                      }
                      double? harga = parseHarga(_hargaController.text);
                      if (harga == null) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Harga tidak valid'),
                          ),
                        );
                        return;
                      }

                      Data data = Data(
                        id: widget.data?.id,
                        product: _nameController.text,
                        harga: harga,
                        nomor: _nomorController.text,
                        address: _addressController.text,
                        category: _selectedCategory ?? categories.first,
                        description: _descriptionController.text,
                        imageUrl: imageUrl,
                        latitude: _selectedLocation?.latitude,
                        longitude: _selectedLocation?.longitude,
                        createdAt: widget.data?.createdAt ?? Timestamp.now(),
                        updatedAt: Timestamp.now(),
                      );

                      if (widget.data == null) {
                        await DataServices.addData(data);
                      } else {
                        await DataServices.updateData(data);
                      }

                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            data: data,
                          ),
                        ),
                      );
                    },
                    child: Text(widget.data == null ? 'Add' : 'Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
