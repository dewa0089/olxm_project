import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olxm_project/screen/detail_screen.dart';
import 'package:olxm_project/model/data.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

class ItemCard extends StatelessWidget {
  final Data data;

  const ItemCard({super.key, required this.data});

  Future<String> _getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        // Mencoba untuk mendapatkan nama kota dari subAdministrativeArea
        String? cityName = placemark.subAdministrativeArea;
        // Jika subAdministrativeArea tidak tersedia, coba gunakan locality
        cityName ??= placemark.locality;
        // Jika keduanya tidak tersedia, kembalikan 'Unknown'
        return cityName ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting city name: $e');
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the price in Rupiah
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.all(8), // Margin between cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                data: data,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            data.imageUrl != null && Uri.parse(data.imageUrl!).isAbsolute
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: data.imageUrl!,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 110,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                  )
                : Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currencyFormatter.format(data.harga),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.product,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_sharp,
                          size: 15,
                        ),
                        FutureBuilder<String>(
                          future: _getCityName(
                              data.latitude ?? 0.0, data.longitude ?? 0.0),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error');
                            } else {
                              return Text(
                                snapshot.data ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
