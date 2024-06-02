import 'package:flutter/material.dart';
import 'package:olxm_project/model/data.dart'; // Import DataList
import 'package:olxm_project/widgets/item_card.dart';
import 'package:olxm_project/services/data_services.dart'; // Import DataServices

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Stream<List<Data>> _dataListStream; // Aliran data list dari Firestore
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

  // Fungsi untuk melakukan filter berdasarkan teks yang dimasukkan
  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredData.clear(); // Mengosongkan data terfilter jika query kosong
      });
    } else {
      setState(() {
        _filteredData = _dataList
            .where(
                (data) => data.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Your Data'),
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
                  // Panggil fungsi filter setiap kali nilai diubah
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
          if (_searchController
              .text.isNotEmpty) // Tampilkan hanya jika TextField terisi
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
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
