import 'package:flutter/cupertino.dart';

class BottomNavigationProvider with ChangeNotifier {
  int _currentIndex = 0;
  String? _profileUserId;

  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  String? get profileUserId => _profileUserId;
  set profileUserId(String? id) {
    _profileUserId = id;
    notifyListeners();
  }

  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners(); // Notify listeners about the change
  }
}
