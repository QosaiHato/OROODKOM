import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/resources/firestore_methods.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPostImagesScreen extends StatefulWidget {
  final Post post;

  EditPostImagesScreen({required this.post});

  @override
  _EditPostImagesScreenState createState() => _EditPostImagesScreenState();
}

class _EditPostImagesScreenState extends State<EditPostImagesScreen> {
  List<File> _imageFiles = [];
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _imageUrls = List.from(widget.post.postUrls ?? []);
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _updatePost() async {
    try {
      // Upload new images
      List<String> newImageUrls = await Future.wait(
          _imageFiles.map((file) => FirestoreMethods().uploadImage(file)));

      // Combine new and existing images
      _imageUrls.addAll(newImageUrls);

      // Update the post with the new image URLs
      await FirestoreMethods().updatePostImages(widget.post.postId, _imageUrls);

      // Navigate back to the previous screen
      Navigator.of(context).pop();
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (index < _imageUrls.length) {
        _imageUrls.removeAt(index);
      } else {
        _imageFiles.removeAt(index - _imageUrls.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Edit Post Images'),
        actions: [
          TextButton(
            onPressed: _updatePost,
            child: Text('Done'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _imageUrls.length + _imageFiles.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          child: index < _imageUrls.length
                              ? Image.network(
                                  _imageUrls[index],
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  _imageFiles[index - _imageUrls.length],
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _pickImage,
              child: Text('Add Image'),
            ),
          ),
        ],
      ),
    );
  }
}
