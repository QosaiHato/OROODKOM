import 'package:finalgradproj/screens/FullImage.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final List<String>? imageUrls;

  PostImage({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return FullImageView(imageUrl: imageUrls!.first);
        }));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrls![index],
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
