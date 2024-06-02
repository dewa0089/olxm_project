import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olxm_project/model/data.dart';

class Screen extends StatefulWidget {
  final Data data;

  const Screen({super.key, required this.data});

  @override
  State<Screen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
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
            const SizedBox(height: 10),
            Text(
              currencyFormatter.format(widget.data.harga),
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              widget.data.name,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Detail Penjual',
              style: TextStyle(fontSize: 16),
            ),
            Text('WhatsApp Number: ${widget.data.nomor}'),
            Text('Kategori: ${widget.data.category}'),
            Text('Alamat: ${widget.data.address}'),
            const SizedBox(height: 10),
            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 16),
            ),
            Text(widget.data.description),
            const SizedBox(height: 10),
            const Text(
              'Specification:',
              style: TextStyle(fontSize: 16),
            ),
            const Text('Quality: Import'),
            const Text('Bahan: Metal Stainless'),
            const Text('Processor: Snapdragon 8 gen 1'),
            const Text('Baterai: 5000 mAH'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan kode onPressed Anda di sini!
                },
                child: const Text('Contact Seller'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child:
                  widget.data.latitude != null && widget.data.longitude != null
                      ? Image.network(
                          'https://maps.googleapis.com/maps/api/staticmap?center=${widget.data.latitude},${widget.data.longitude}&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C${widget.data.latitude},${widget.data.longitude}&key=YOUR_API_KEY', // Ganti dengan API key Google Maps Static API yang sebenarnya
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(),
            ),
            const SizedBox(height: 10),
            const Text(
              'Komentar',
              style: TextStyle(fontSize: 16),
            ),
            // Tambahkan bagian komentar Anda di sini
          ],
        ),
      ),
    );
  }
}
