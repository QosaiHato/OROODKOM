import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/screens/post_card.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SmallPostCard extends StatelessWidget {
  final Post post;
  final String? currentUserUid;

  SmallPostCard({Key? key, required this.post, this.currentUserUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive sizes
    final cardWidth = screenWidth * 0.9; // 90% of screen width
    final cardHeight = screenHeight * 0.45; // 25% of screen height
    final imageWidth = cardWidth * 0.75; // 75% of card width
    final imageHeight = cardHeight * 0.75; // 75% of card height
    final priceTopPadding = screenHeight * 0.29; // Adjusted top position
    String currentuser = FirebaseAuth.instance.currentUser!.uid;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(FeatherIcons.arrowRight),
              ),
            ),
            body: ListView(
              children: [
                PostCard(
                  snap: post,
                  currentUserUid: currentuser,
                )
              ],
            ),
          ),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: lightgrayColor.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          width: cardWidth,
          height: cardHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: imageWidth,
                      height: imageHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: post.postUrls!.isNotEmpty
                            ? Image.network(
                                post.postUrls!
                                    .first, // Use only the first image URL
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey, // Placeholder color
                                child: Center(
                                  child: Text('No image available'),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      top: priceTopPadding,
                      child: Container(
                        height: 25,
                        width: cardWidth * 0.2, // 20% of card width
                        decoration: BoxDecoration(
                          color: whiteColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            "${post.price}\$",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: post.productName,
                        )
                      ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: lightgrayColor.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text("${post.averageRating.toStringAsFixed(2)}  "),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
