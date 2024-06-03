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
      'product': data.product,
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
      'userId': data.userId, // Corrected userId access
    };

    try {
      await _dataCollection.add(newData);
    } catch (e) {
      // Handle error
      print('Error adding data: $e');
    }
  }

  static Future<void> updateData(Data data) async {
    Map<String, dynamic> updatedData = {
      'product': data.product,
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
      'userId': data.userId,
    };

    try {
      await _dataCollection.doc(data.id).update(updatedData);
    } catch (e) {
      // Handle error
      print('Error updating data: $e');
    }
  }

  static Future<void> deleteData(Data data) async {
    try {
      await _dataCollection.doc(data.id).delete();
    } catch (e) {
      // Handle error
      print('Error deleting data: $e');
    }
  }

  static Future<QuerySnapshot> retrieveData() async {
    try {
      return await _dataCollection.get();
    } catch (e) {
      // Handle error
      print('Error retrieving data: $e');
      rethrow;
    }
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
          product: data['product'],
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
          userId: data['userId'] as String?,
        );
      }).toList();
    });
  }
}
