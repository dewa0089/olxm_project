import 'package:flutter/material.dart';
import 'package:olxm_project/model/data.dart';
import 'package:olxm_project/widgets/item_card.dart';
import 'package:olxm_project/services/data_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Stream<List<Data>> _dataListStream;
  List<Data> _dataList = [];
  List<Data> _filteredData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataListStream = DataServices.getDataList();
    _dataListStream.listen((List<Data> data) {
      setState(() {
        _dataList = data;
      });
    });
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredData.clear();
      });
    } else {
      setState(() {
        _filteredData = _dataList
            .where((data) =>
                data.product.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
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
                "Search Your Items",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple[50],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: 'Search Data',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  final data = _filteredData[index];
                  return ItemCard(
                    data: data,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
