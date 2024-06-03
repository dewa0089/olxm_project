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
  final String? id;
  final String product;
  final double harga;
  final String nomor;
  final String category;
  final String address;
  final String description;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final String? userId; // Added userId

  Data({
    this.id,
    required this.product,
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
    this.userId, // Initialize userId
  });

  // Tambahkan userId ke metode fromMap dan toMap
  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      id: map['id'] as String?,
      product: map['product'] as String,
      harga: (map['harga'] as num).toDouble(),
      nomor: map['nomor'] as String,
      address: map['address'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      imageUrl: map['image_url'] as String?,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      createdAt: map['created_at'] as Timestamp?,
      updatedAt: map['updated_at'] as Timestamp?,
      userId: map['userId'] as String?, // Get userId
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product,
      'harga': harga,
      'nomor': nomor,
      'address': address,
      'category': category,
      'description': description,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'userId': userId, // Save userId
    };
  }
}

class Comment {
  final String id;
  final String userId;
  final String text;
  final Timestamp createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      userId: map['userId'] as String,
      text: map['text'] as String,
      createdAt: (map['createdAt'] as Timestamp?) ?? Timestamp.now(),
    );
  }
}
