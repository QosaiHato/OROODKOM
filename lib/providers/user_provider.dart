import 'dart:typed_data';


import 'package:finalgradproj/models/user.dart' as model;
import 'package:finalgradproj/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  model.User? get getUser => _user;

  Future<void> refreshUser({String? uid}) async {
    try {
      model.User? user = await _authMethods.getUserDetails(uid: uid);
      if (user != null) {
        _user = user;
        notifyListeners();
      } else {
        // Handle the case where user is null
        throw Exception("User not found");
      }
    } catch (e) {
      // Handle the error appropriately (e.g., show a snackbar)
      print("Error fetching user details: $e");
    }
  }
}
