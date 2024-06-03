import 'package:flutter/material.dart';
import 'package:olxm_project/model/data.dart';
import 'package:olxm_project/widgets/item_card.dart';
import 'package:olxm_project/services/data_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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
        elevation: 0,
        backgroundColor: Colors.deepPurple[100],
        title: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Favorite Items",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              Image.asset(
                "assets/image/logo.png",
                width: 55.0,
                height: 55.0,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                childAspectRatio: 0.7,
              ),
              itemCount: favoriteData.length,
              itemBuilder: (ctx, index) {
                return ItemCard(data: favoriteData[index]);
              },
            )),
          ],
        ),
      ),
    );
  }
}
