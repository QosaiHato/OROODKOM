import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  double _rating = 0.0;

  double get rating => _rating;

  void setInitialRating(double rating) {
    _rating = rating;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => notifyListeners()); // Update UI after build phase
  }

  // Add the updateRating method
  void updateRating(double newRating) {
    _rating = newRating;
    notifyListeners(); // Notify listeners of the change
  }
}
