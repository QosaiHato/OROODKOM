import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter/material.dart';

class ImageAndPrice extends StatelessWidget {
  final Post post;
  const ImageAndPrice({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final priceContainerHeight = screenHeight * 0.04; // 4% of screen height
    final priceContainerWidth = screenWidth * 0.25; // 25% of screen width
    final priceFontSize = priceContainerHeight * 0.5; // 50% of the container height

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth * 0.04), // 4% of screen width
          child: post.postUrls != null && post.postUrls!.isNotEmpty
              ? Image.network(
                  post.postUrls!.first, // Show only the first image
                  fit: BoxFit.cover,
                  width: screenWidth, // Full width of the screen
                  height: screenHeight, // Full height of the screen
                )
              : Container(
                  width: screenWidth, // Full width of the screen
                  height: screenHeight, // Full height of the screen
                  color: Colors.grey, // Placeholder color
                  child: Center(
                    child: Text('No image available'),
                  ),
                ),
        ),
        Positioned(
          top: screenHeight * 0.11,
          child: Container(
            height: priceContainerHeight,
            width: priceContainerWidth,
            decoration: BoxDecoration(
              color: whiteColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(
                  screenWidth * 0.5), // 50% of screen width for circular effect
            ),
            child: Center(
              child: Text(
                "${post.price}\$",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor.withOpacity(0.8),
                  fontSize: priceFontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}