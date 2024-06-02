import 'package:cloud_firestore/cloud_firestore.dart';

final List<String> categories = [
  'Handphone',
  'Tablet',
  'Laptop',
  'Televisi',
  'Game & Console',
];

List<Data> filterDataByCategory(List<Data> dataList, String category) {
  if (category == 'All') {
    return dataList;
  } else {
    return dataList.where((data) => data.category == category).toList();
  }
}

class Data {
  String? id;
  final String name;
  final double harga;
  final String nomor;
  final String category;
  final String address;
  final String description;
  String? imageUrl;
  double? latitude;
  double? longitude;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Data({
    this.id,
    required this.name,
    required this.harga,
    required this.nomor,
    required this.category,
    required this.address,
    required this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Data(
      id: doc.id,
      name: data['name'],
      harga: (data['harga'] as num).toDouble(),
      nomor: data['nomor'],
      category: data['category'],
      address: data['address'],
      description: data['description'],
      imageUrl: data['image_url'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      createdAt: data['created_at'] as Timestamp?,
      updatedAt: data['updated_at'] as Timestamp?,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'harga': harga,
      'nomor': nomor,
      'category': category,
      'address': address,
      'description': description,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
