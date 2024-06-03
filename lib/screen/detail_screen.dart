import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olxm_project/model/data.dart';
import 'package:olxm_project/screen/google_maps.dart';
import 'package:olxm_project/screen/posting_screen.dart';
import 'package:olxm_project/services/data_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Data data;

  const DetailScreen({super.key, required this.data});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  String? currentUserId;
  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUserId = user?.uid;
    });
  }

  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool favorite = prefs.getBool('favorite_${widget.data.id}') ?? false;
    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> _saveFavoriteStatus(bool favoriteStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorite_${widget.data.id}', favoriteStatus);

    List<String> favoriteIds = prefs.getStringList('favoriteIds') ?? [];

    if (favoriteStatus) {
      if (widget.data.id != null) {
        favoriteIds.add(widget.data.id!);
      }
    } else {
      if (widget.data.id != null) {
        favoriteIds.remove(widget.data.id!);
      }
    }

    await prefs.setStringList('favoriteIds', favoriteIds);
  }

  Future<void> _toggleFavorite() async {
    bool favoriteStatus = !isFavorite;
    await _saveFavoriteStatus(favoriteStatus);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final Uri whatsapp = Uri.parse('https://wa.me/62${widget.data.nomor}');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 22, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Hero(
              tag: widget.data.imageUrl ?? 'no_image',
              child: widget.data.imageUrl != null
                  ? Image.network(
                      widget.data.imageUrl!,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencyFormatter.format(widget.data.harga),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.data.userId == currentUserId)
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Hapus'),
                              content: Text(
                                  'Yakin ingin menghapus data \'${widget.data.product}\' ?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Hapus'),
                                  onPressed: () {
                                    DataServices.deleteData(widget.data)
                                        .whenComplete(() => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PostingScreen(),
                                              ),
                                            ));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Icon(
                          Icons.delete,
                          size: 30,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    widget.data.product,
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Divider(
                color: Color.fromARGB(255, 14, 14, 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    'Detail Penjualan:',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    'No. Handphone: ${widget.data.nomor}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    'Kategori: ${widget.data.category}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    'Alamat: ${widget.data.address}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Divider(
                color: Color.fromARGB(255, 14, 14, 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    'Deskripsi Penjualan:',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    widget.data.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (await launchUrl(whatsapp)) {
                    print('launched url');
                  } else {
                    print('could not launch url');
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 50),
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Contact Seller Now'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    'Lokasi Penjual:',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  widget.data.latitude != null && widget.data.longitude != null
                      ? SizedBox(
                          height: 200,
                          child: GoogleMapsScreen(
                            latitude: widget.data.latitude!,
                            longitude: widget.data.longitude!,
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.location_off,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    'Komentar:',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Add widget to display comments here
          ],
        ),
      ),
    );
  }
}
