import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Adding image to storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    try {
      // Ensure user is logged in before uploading
      if (_auth.currentUser == null) {
        throw Exception('User is not logged in');
      }

      Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

      if (isPost) {
        String id = const Uuid().v1();
        ref = ref.child(id);
      }

      UploadTask uploadTask = ref.putData(file);

      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image to storage: $e');
      throw e;
    }
  }

  // Method to fetch image from a given URL
  Future<Uint8List> getImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      debugPrint('Error fetching image from URL: $e');
      throw e;
    }
  }
}
