import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OLXM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                    hintText: 'Search Favorite',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(height: 20),
              const Text(
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  'Your Favorite Product: '),
            ],
          ),
        ),
      ),
    );
  }
}
