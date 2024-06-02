import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:olxm_project/model/data.dart';

class DataServices {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _dataCollection =
      _database.collection('olxm');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImage(
      File? imageFile, Uint8List? webImage) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('images/$fileName');

      UploadTask uploadTask;
      if (kIsWeb && webImage != null) {
        uploadTask = ref.putData(webImage);
      } else if (imageFile != null) {
        uploadTask = ref.putFile(imageFile);
      } else {
        return null;
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // ignore: avoid_print
      print('Error uploading image: $e');
      return null;
    }
  }

  static Future<void> addData(Data data) async {
    Map<String, dynamic> newData = {
      'name': data.name,
      'harga': data.harga,
      'nomor': data.nomor,
      'category': data.category,
      'address': data.address,
      'description': data.description,
      'image_url': data.imageUrl,
      'latitude': data.latitude,
      'longitude': data.longitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _dataCollection.add(newData);
  }

  static Future<void> updateData(Data data) async {
    Map<String, dynamic> updatedData = {
      'name': data.name,
      'harga': data.harga,
      'nomor': data.nomor,
      'category': data.category,
      'address': data.address,
      'description': data.description,
      'image_url': data.imageUrl,
      'latitude': data.latitude,
      'longitude': data.longitude,
      'created_at': data.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _dataCollection.doc(data.id).update(updatedData);
  }

  static Future<void> deleteData(Data data) async {
    await _dataCollection.doc(data.id).delete();
  }

  static Future<QuerySnapshot> retrieveData() {
    return _dataCollection.get();
  }

  static Stream<List<Data>> getDataList() {
    return _dataCollection
        .orderBy('created_at',
            descending: true) // Order by created_at in descending order
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
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
          latitude:
              data['latitude'] != null ? data['latitude'] as double : null,
          longitude:
              data['longitude'] != null ? data['longitude'] as double : null,
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }
}
