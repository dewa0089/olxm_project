import 'package:cloud_firestore/cloud_firestore.dart';

final List categories = [
  'Handphone',
  'Tablet',
  'Laptop',
  'Televisi',
  'Game & Console',
];

class Note {
  String? id;
  final String name;
  final String nomor;
  final String category;
  final String address;
  final String description;
  String? imageUrl;
  double? latitude;
  double? longitude;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Note({
    this.id,
    required this.name,
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

  factory Note.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      name: data['name'],
      nomor: data['nomor'],
      category: data['category'],
      address: data['address'],
      description: data['description'],
      imageUrl: data['image_url'],
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
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
