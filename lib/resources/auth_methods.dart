import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:finalgradproj/models/user.dart' as model;
import 'package:finalgradproj/models/user.dart';
import 'package:finalgradproj/models/user.dart';

import 'package:finalgradproj/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User?> getUserDetails({String? uid}) async {
    String? targetUid = uid ?? _auth.currentUser?.uid;

    if (targetUid != null) {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(targetUid).get();
      return model.User.fromSnap(snap);
    }
    return null;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
    required Uint8List businessProofFile,
    required UserType userType,
    String? businessName,
    String? phoneNumber,
    String? whatsappNumber,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        // Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String? businessImageUrl;
        String? businessProofImageUrl;
        if (userType == UserType.business) {
          businessImageUrl = await StorageMethods()
              .uploadImageToStorage('businessProfilePics', file, false);
          businessProofImageUrl = await StorageMethods().uploadImageToStorage(
              'businessProofPics', businessProofFile, false);
        }

        // Add user to database
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: businessImageUrl ?? '',
          businessProofUrl: businessProofImageUrl ?? '',
          email: email,
          bio: bio,
          userType: userType,
          businessName: businessName,
          phoneNumber: phoneNumber,
          whatsappNumber: whatsappNumber,
          verificationStatus: userType == UserType.business
              ? VerificationStatus.pending
              : VerificationStatus.approved,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> sendNotification(
      String userId, String title, String body) async {
    // Implementation of the sendNotification method
    // You can use Firebase Cloud Functions or a third-party notification service to send the notification
    // For example, you can use the Firebase Cloud Messaging API to send push notifications
    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<String> updateUserVerification(
      String uid, VerificationStatus status) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'verificationStatus': status.toString().split('.').last,
      });

      // Notify the business user about the status change
      model.User? user = await getUserDetails(uid: uid);
      if (user != null) {
        // Send a notification or email to the business user
        // based on the new verification status
        if (status == VerificationStatus.approved) {
          // Notify the user that their account has been approved
          sendNotification(user.email, 'Account Approved',
              'Your business account has been approved.');
        } else if (status == VerificationStatus.rejected) {
          // Notify the user that their account has been rejected
          sendNotification(user.email, 'Account Rejected',
              'Your business account has been rejected. Please contact the admin for more information.');
        }
      }

      return 'success';
    } catch (e) {
      return 'Error updating user verification: $e';
    }
  }

  Future<String> updateUserDetails({
    required String username,
    required String email,
    required String bio,
    String? phoneNumber,
    String? whatsappNumber,
    String? photoUrl,
  }) async {
    try {
      Map<String, dynamic> data = {
        'username': username,
        'email': email,
        'bio': bio,
        'phoneNumber': phoneNumber,
        'whatsappNumber': whatsappNumber,
      };

      if (photoUrl != null) {
        data['photoUrl'] = photoUrl;
      }

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(data);

      return "success";
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> getCurrentUserPassword() async {
    String? email = _auth.currentUser?.email;
    if (email != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: "",
        );
        UserCredential userCredential =
            await _auth.currentUser!.reauthenticateWithCredential(credential);
        return "success";
      } catch (e) {
        return e.toString();
      }
    } else {
      return "User not authenticated";
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> verifyBusinessUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isVerified': true,
      });
      return "User verified successfully";
    } catch (e) {
      return "Error verifying user: $e";
    }
  }

  Future<String> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> deleteUser(String uid) async {
    try {
      // Delete user from Firestore
      await _firestore.collection('users').doc(uid).delete();

      // Delete user from Firebase Authentication
      firebase_auth.User? user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        await user.delete();
      } else {
        firebase_auth.UserCredential userCredential =
            await _auth.signInWithCredential(
          firebase_auth.EmailAuthProvider.credential(
            email: user!.email!,
            password:
                "", // Provide the password or use a secure method to reauthenticate
          ),
        );
        await userCredential.user!.delete();
      }

      return "success";
    } catch (error) {
      return "Error deleting user: $error";
    }
  }

  Future<String> sendCustomResetEmail(
    String email,
    String subject,
    String body,
  ) async {
    try {
      // Send the password reset email using Firebase Authentication
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Send the custom email using Dart's built-in dart:io and dart:convert libraries
      final uri = Uri.parse('mailto:$email?subject=$subject&body=$body');
      await Process.start('open', [uri.toString()]).then((process) {
        process.stdout.transform(utf8.decoder).listen(print);
        process.stderr.transform(utf8.decoder).listen(print);
      });

      return "success"; // Return success if email is sent successfully
    } catch (e) {
      print('Error sending email: $e');
      return "error"; // Return error if email sending fails
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
