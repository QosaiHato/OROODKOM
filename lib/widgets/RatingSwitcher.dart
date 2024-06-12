import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingSwitcher extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingUpdate;

  const RatingSwitcher({
    Key? key,
    required this.initialRating,
    required this.onRatingUpdate,
  }) : super(key: key);

  @override
  _RatingSwitcherState createState() => _RatingSwitcherState();
}

class _RatingSwitcherState extends State<RatingSwitcher> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: 30,
      initialRating: _currentRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.yellow,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _currentRating = rating;
        });
        widget.onRatingUpdate(rating);
      },
    );
  }
}
