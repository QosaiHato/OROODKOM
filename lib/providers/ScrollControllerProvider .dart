import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollControllerProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  set isVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }

  void onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      isVisible = true; // Show when scrolling down
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isVisible = false; // Hide when scrolling up
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
