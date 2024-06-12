import 'dart:typed_data';

import 'package:finalgradproj/providers/user_provider.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/AddPost/Fillinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PickImage extends StatefulWidget {
  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  List<Uint8List> _images = [];
  String? currentUser = FirebaseAuth.instance.currentUser!.uid;

  void _selectImage(BuildContext context) async {
    List<XFile>? files = await ImagePicker().pickMultiImage();
    if (files != null) {
      for (var file in files) {
        final bytes = await file.readAsBytes();
        setState(() {
          _images.add(Uint8List.fromList(bytes));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "اختر صور المنشور",
              style: TextStyle(color: Colors.black, fontSize: 32),
            ),
            Text("اضغط على الصور لتحديدها"),
            SizedBox(height: 64),
            // Image selection widget
            _images.isNotEmpty
                ? Container(
                    height: 150, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _images.length) {
                          // Last item is for adding more images
                          return GestureDetector(
                            onTap: () => _selectImage(context),
                            child: Container(
                              width: 150, // Adjust size as needed
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                              ),
                              child: Icon(
                                FeatherIcons.plusCircle,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 150, // Adjust size as needed
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(
                                  _images[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                : Hero(
                    tag: "image_picker",
                    child: GestureDetector(
                      onTap: () => _selectImage(context),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: Icon(
                          FeatherIcons.image,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 50),
            // Next button
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(maincolor),
              ),
              onPressed: _images.isNotEmpty
                  ? () {
                      // Navigate to SecondPage with selected images
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondPage(
                            images: _images,
                            currentUserId: userProvider.getUser!.uid,
                            currentUsername: userProvider.getUser!.username,
                            profileImageUrl: userProvider.getUser!.photoUrl,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(
                'Next',
                style: TextStyle(color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
