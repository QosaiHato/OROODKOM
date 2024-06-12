import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/models/user.dart' as model;
import 'package:finalgradproj/resources/auth_methods.dart';
import 'package:finalgradproj/resources/firestore_methods.dart';
import 'package:finalgradproj/screens/FullImage.dart';
import 'package:finalgradproj/screens/edit_post_screen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/RatingSwitcher.dart';
import 'package:finalgradproj/widgets/postCard/expandable_post_description.dart';
import 'package:finalgradproj/widgets/postCard/post_info.dart';
import 'package:finalgradproj/widgets/postCard/user_avatar_and_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostCard extends StatefulWidget {
  final Post snap;
  final String currentUserUid;

  const PostCard({
    Key? key,
    required this.snap,
    required this.currentUserUid,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  double? _userRating;
  double _averageRating = 0.0;
  final AuthMethods _authMethods = AuthMethods();
  model.User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchUserDetails();
    if (_currentUser != null) {
      await _fetchUserRating();
      await _calculateAverageRating();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchUserDetails() async {
    _currentUser = await _authMethods.getUserDetails();
  }

  Future<double?> _fetchUserRating() async {
    if (_currentUser != null) {
      try {
        final postDoc = await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap.postId)
            .get();
        if (postDoc.exists) {
          final ratingsMap = postDoc.data()?['ratings'] as Map<String, dynamic>;
          if (ratingsMap != null && ratingsMap.containsKey(_currentUser?.uid)) {
            _userRating = ratingsMap[_currentUser?.uid];
            return _userRating;
          } else {
            print('No rating data available for the current user');
            return 0.0; // Return 0.0 if no rating data is available
          }
        } else {
          print('Post document not found');
          return null;
        }
      } catch (e) {
        print('Error fetching user rating: $e');
        return null;
      }
    } else {
      print('_currentUser is null');
      return null; // Return null if user is not logged in
    }
  }

  Future<void> _calculateAverageRating() async {
    try {
      final postDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap.postId)
          .get();
      final ratingsMap = postDoc.data()?['ratings'] as Map<String, dynamic>;
      final totalRatings =
          ratingsMap.values.fold(0.0, (sum, rating) => sum + rating);
      final numRatings = ratingsMap.length;
      _averageRating = numRatings > 0 ? totalRatings / numRatings : 0.0;
    } catch (e) {
      print('Error calculating average rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
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
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_currentUser != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserAvatarAndInfo(
                      snap: widget.snap,
                      currentUserUid: widget.currentUserUid,
                      usertype: _currentUser!.userType,
                    ),
                  ),
                _buildPostImage(), // Use _buildPostImage method
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              _buildRatingBarAndButton(),
                              Text(
                                "${_averageRating.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                PostInfo(snap: widget.snap),
                ExpandablePostDescription(snap: widget.snap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    if (widget.snap.postUrls != null && widget.snap.postUrls!.isNotEmpty) {
      if (widget.snap.postUrls!.length == 1) {
        return Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return FullImageView(imageUrl: widget.snap.postUrls!.first);
              }));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Stack(
                  children: [
                    Image.network(
                      widget.snap.postUrls!.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey, // Placeholder color
                          child: Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        );
                      },
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        // If there are multiple images, display them in a horizontal list
        return Container(
          height: MediaQuery.of(context).size.height *
              0.4, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.snap.postUrls!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    right: 8.0), // Add padding for all items
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FullImageView(
                          imageUrl: widget.snap.postUrls![index]);
                    }));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            widget.snap.postUrls![index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey, // Placeholder color
                                child: Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                ),
                              );
                            },
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    } else {
      // If there are no images, return an empty container
      return Container();
    }
  }

  Widget _buildRatingBarAndButton() {
    return FutureBuilder<double?>(
      future: _fetchUserRating(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 50,
            child: LinearProgressIndicator(
              color: Colors.yellow,
            ),
          );
        } else if (snapshot.hasData) {
          final userRating = snapshot.data ?? 0.0;
          return RatingSwitcher(
            initialRating: userRating,
            onRatingUpdate: (rating) => _updateUserRatingInFirebase(rating),
          );
        } else if (snapshot.hasError) {
          print('Error fetching user rating: ${snapshot.error}');
          return const Text('Error fetching rating');
        } else {
          // Check if _currentUser is not null
          if (_currentUser != null) {
            return const Text('No rating data available');
          } else {
            return const SizedBox
                .shrink(); // Return an empty widget if _currentUser is null
          }
        }
      },
    );
  }

  Future<void> _updateUserRatingInFirebase(double rating) async {
    try {
      if (_currentUser != null) {
        await FirestoreMethods().updateUserRating(
          widget.snap.postId,
          _currentUser!.uid,
          rating,
        );
        // Fetch updated user rating and recalculate average rating
        await _fetchUserRating();
        await _calculateAverageRating();
        // Update UI
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error updating user rating: $e');
    }
  }
}
