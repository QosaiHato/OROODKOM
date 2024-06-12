import 'dart:typed_data';

import 'package:finalgradproj/models/user.dart';
import 'package:finalgradproj/utils/utils.dart';
import 'package:finalgradproj/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

import 'package:finalgradproj/utils/colors.dart';
import 'package:image_picker/image_picker.dart';

class Signup3 extends StatefulWidget {
  final TextEditingController businessNameController;
  final UserType selectedUserType;
  final VoidCallback onRegister;
  final void Function(Uint8List) onBusinessProofImagePicked;

  const Signup3({
    Key? key,
    required this.businessNameController,
    required this.selectedUserType,
    required this.onRegister,
    required this.onBusinessProofImagePicked,
  }) : super(key: key);

  @override
  _Signup3State createState() => _Signup3State();
}

class _Signup3State extends State<Signup3> {
  Uint8List? _businessProofImage;
  bool _isImageLoading = false;

  Future<void> _selectBusinessProofImage() async {
    setState(() {
      _isImageLoading = true;
    });

    try {
      Uint8List? image = await pickImage(ImageSource.gallery);
      if (image != null) {
        setState(() {
          _businessProofImage = image;
        });
        widget.onBusinessProofImagePicked(image);
      }
    } catch (e) {
      showSnackBar("Error selecting image: $e", context);
    } finally {
      setState(() {
        _isImageLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.selectedUserType == UserType.business)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  labelText: 'Business Name',
                  hintText: 'Enter your business name',
                  textEditingController: widget.businessNameController,
                  texttype: TextInputType.text,
                  nextnode: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                const Text('Business Proof Image'),
                const SizedBox(height: 8),
                if (_businessProofImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.memory(
                      _businessProofImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: _selectBusinessProofImage,
                    child: _isImageLoading
                        ? const CircularProgressIndicator()
                        : const Text('Upload Proof Image'),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          // ElevatedButton(
          //   onPressed: widget.onRegister,
          //   style: ElevatedButton.styleFrom(
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   ),
          //   child: Text(
          //     widget.selectedUserType == UserType.business
          //         ? 'Next'
          //         : 'Register',
          //     style: const TextStyle(fontSize: 18),
          //   ),
          // ),
        ],
      ),
    );
  }
}
