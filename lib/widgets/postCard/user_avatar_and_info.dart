import 'package:finalgradproj/models/user.dart';
import 'package:finalgradproj/resources/firestore_methods.dart';
import 'package:finalgradproj/screens/ProfileScreen/profile_screen.dart';
import 'package:finalgradproj/screens/edit_post_screen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/edit_post_images.dart';
import 'package:flutter/material.dart';
class UserAvatarAndInfo extends StatelessWidget {
  final dynamic snap;
  final String currentUserUid;
  UserType usertype;
  UserAvatarAndInfo({
    required this.snap,
    required this.currentUserUid,
    required this.usertype,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: ProfileScreen(
                uid: snap.uid,
                appbar: true,
              ),
              backgroundColor: backgroundColor,
            ),
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(snap.profImage),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '   ${snap.username}  ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (snap.uid == currentUserUid || usertype == UserType.admin)
            PopupMenuButton(
              icon: Icon(Icons.menu),
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditPostScreen(
                        post: snap,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeletePostDialog(context);
                } else if (value == 'changeImages') {
                  _navigateToEditImagesScreen(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
                PopupMenuItem(
                  value: 'changeImages',
                  child: Text('Change Images'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showDeletePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirestoreMethods().deletePost(snap.postId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditImagesScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPostImagesScreen(
          post: snap,
        ),
      ),
    );
  }
}
