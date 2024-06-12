import 'dart:io';
import 'dart:typed_data';
import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = _storage.ref().child('posts').child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updatePostImages(String postId, List<String> imageUrls) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'postUrls': imageUrls,
      });
    } catch (e) {
      print('Error updating post images: $e');
    }
  }

  Future<void> updatePost(
    String postId,
    String description,
    String category,
    String username,
    String profImage,
    String productName,
    String address,
    String phoneNumber,
    String whatsappNumber,
    String city,
    double price,
    List<String>? postUrls,
  ) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'description': description,
        'category': category,
        'username': username,
        'profImage': profImage,
        'productName': productName,
        'address': address,
        'phoneNumber': phoneNumber,
        'whatsappNumber': whatsappNumber,
        'city': city,
        'price': price,
        'postUrls': postUrls,
      });
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  Future<String> uploadPost(
    String description,
    List<Uint8List> files, // Changed to a list of image files
    String uid,
    String username,
    String profImage,
    String productName,
    String address,
    String phoneNumber,
    String whatsappNumber,
    String city,
    String category,
    double price,
  ) async {
    String res = "Some error occurred";
    try {
      List<String> photoUrls = [];
      for (Uint8List file in files) {
        String photoUrl =
            await StorageMethods().uploadImageToStorage('posts', file, true);
        photoUrls.add(photoUrl);
      }

      String postId = const Uuid().v1();
      double averageRating = 0.0;

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrls: photoUrls, // Changed to a list of URLs
        profImage: profImage,
        productName: productName,
        address: address,
        phoneNumber: phoneNumber,
        whatsappNumber: whatsappNumber,
        price: price,
        category: category,
        city: city,
        ratings: {}, // Initialize empty ratings map
        averageRating: averageRating,
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<Map<String, dynamic>> getLatestSnapshot(String postId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception("Post not found");
      }
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUserRating(
      String postId, String userId, double rating) async {
    try {
      // Update the user's rating in the 'posts' document
      await _firestore.collection('posts').doc(postId).update({
        'ratings.$userId': rating,
      });

      // Update the average rating for the post
      await _updateAverageRating(postId);
    } catch (e) {
      print('Error updating user rating: $e');
    }
  }

  Future<double> getUserRating(String postId, String uid) async {
    try {
      final userRatingsRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('user_ratings')
          .doc(uid);
      final userRatingsSnapshot = await userRatingsRef.get();

      if (userRatingsSnapshot.exists) {
        return userRatingsSnapshot.data()!['rating'] as double;
      } else {
        // User rating doesn't exist, return 0
        return 0.0;
      }
    } catch (e) {
      print('Error fetching user rating: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future<void> _updateAverageRating(String postId) async {
    try {
      // Fetch all the ratings for the post
      final postDoc = await _firestore.collection('posts').doc(postId).get();
      final ratingsMap = postDoc.data()?['ratings'] as Map<String, dynamic>;

      // Calculate the new average rating
      final ratings = ratingsMap.values.toList().cast<double>();
      final averageRating = ratings.isEmpty
          ? 0.0
          : ratings.reduce((a, b) => a + b) / ratings.length;

      // Update the average rating in the 'posts' document
      await _firestore.collection('posts').doc(postId).update({
        'averageRating': averageRating,
      });
    } catch (e) {
      print('Error updating average rating: $e');
    }
  }
}
