import 'package:cloud_firestore/cloud_firestore.dart';
class Post {
  final String description;
  final String category;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final List<String>? postUrls; // Make postUrls nullable
  final String profImage;
  final String productName;
  final String address;
  final String phoneNumber;
  final String whatsappNumber;
  final String city;
  final Map<String, double> ratings; // Map of user ID and rating value
  final double averageRating; // Calculated average rating for the post
  final double price;

  Post({
    required this.description,
    required this.category,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrls, // Make postUrls nullable
    required this.profImage,
    required this.productName,
    required this.address,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.price,
    required this.city,
    required this.ratings,
    required this.averageRating,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'category': category,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'postUrls': postUrls,
        'profImage': profImage,
        'price': price,
        "productName": productName,
        "address": address,
        "phoneNumber": phoneNumber,
        "whatsappNumber": whatsappNumber,
        "city": city,
        'ratings': ratings,
        'averageRating': averageRating,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>?;
    if (snapshot == null) {
      throw Exception("Document data is null!");
    }

    return Post(
      description: snapshot['description'] as String,
      uid: snapshot['uid'] as String,
      username: snapshot['username'] as String,
      postId: snapshot['postId'] as String,
      datePublished: (snapshot['datePublished'] as Timestamp).toDate(),
      postUrls: List<String>.from(snapshot['postUrls'] ?? []),
      profImage: snapshot['profImage'] as String,
      productName: snapshot['productName'] as String? ?? "No product name provided",
      address: snapshot['address'] as String,
      phoneNumber: snapshot['phoneNumber'] as String,
      whatsappNumber: snapshot['whatsappNumber'] as String,
      price: snapshot['price'] as double,
      category: snapshot['category'] as String? ?? "No category provided",
      city: snapshot['city'] as String? ?? "No city provided",
      ratings: Map<String, double>.from(snapshot['ratings'] ?? {}),
      averageRating: snapshot['averageRating'] as double? ?? 0.0,
    );
  }
}
