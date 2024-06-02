import 'package:flutter/material.dart';
import 'package:olxm_project/model/data.dart';
import 'package:olxm_project/widgets/item_card.dart';
import 'package:olxm_project/services/data_services.dart'; // Import DataServices
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Data> favoriteData = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteData();
  }

  Future<void> _loadFavoriteData() async {
    List<Data> allData = await DataServices.getDataList().first;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteIds') ?? [];

    setState(() {
      favoriteData =
          allData.where((data) => favoriteIds.contains(data.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                // Implement search functionality here if needed
              },
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Favorite Items:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteData.length, // Use filtered data length
              itemBuilder: (ctx, index) {
                return ItemCard(data: favoriteData[index]); // Use filtered data
              },
            )),
          ],
        ),
      ),
    );
  }
}
