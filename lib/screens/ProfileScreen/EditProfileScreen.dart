import 'dart:typed_data';

import 'package:finalgradproj/models/user.dart';
import 'package:finalgradproj/resources/auth_methods.dart';
import 'package:finalgradproj/resources/storage_methods.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/utils/utils.dart';
import 'package:finalgradproj/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Uint8List? _image;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    User? user = await AuthMethods().getUserDetails();

    if (!mounted) return; // Check if widget is still mounted
    if (user != null) {
      setState(() {
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _bioController.text = user.bio;

        // Extract the phone number without the country code prefix
        String phoneNumber = user.phoneNumber ?? '';
        if (phoneNumber.startsWith('+962')) {
          _phoneController.text = phoneNumber.substring(4);
        } else {
          _phoneController.text = phoneNumber;
        }
        String whatsappNumber = user.whatsappNumber ?? "";
        if (whatsappNumber.startsWith('+962')) {
          _whatsappController.text = whatsappNumber.substring(4);
        } else {
          _whatsappController.text = user.whatsappNumber ?? "";
        }

        _photoUrl = user.photoUrl;
      });

      // Fetch and set the profile image if it exists
      if (_photoUrl != null) {
        Uint8List imageBytes =
            await StorageMethods().getImageFromUrl(_photoUrl!);
        if (!mounted) return; // Check if widget is still mounted
        setState(() {
          _image = imageBytes;
        });
      }
    }
  }

  void _selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (!mounted) return; // Check if widget is still mounted
    setState(() {
      _image = im;
    });
  }

  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? imageUrl;
      if (_image != null) {
        imageUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', _image!, false);
      }

      String res = await AuthMethods().updateUserDetails(
        username: _usernameController.text,
        email: _emailController.text,
        bio: _bioController.text,
        phoneNumber: _phoneController.text,
        whatsappNumber: _whatsappController.text,
        photoUrl: imageUrl ?? _photoUrl, // Use the new or existing photo URL
      );

      if (!mounted) return; // Check if widget is still mounted
      setState(() {
        _isLoading = false;
      });

      if (res == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $res')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(FeatherIcons.arrowRight),
        ),
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.memory(
                      _image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                else if (_photoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      _photoUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey[800],
                    ),
                  ),
                TextButton(
                  onPressed: _selectImage,
                  child: Text('Change Profile Picture', style: TextStyle(color: maincolor)),
                ),
                CustomTextField(
                  passwordVisible: false,
                  labelText: '',
                  hintText: 'اسم المستحدم',
                  isPassword: false,
                  textEditingController: _usernameController,
                  nextnode: TextInputAction.next,  texttype: TextInputType.text,
                  checks: '',
                ),
                CustomTextField(
                  passwordVisible: false,
                  labelText: '',
                  hintText: 'الايميل',
                  isPassword: false,
                  textEditingController: _emailController,
                  nextnode: TextInputAction.next, texttype: TextInputType.text,
                  checks: '',
                ),
                CustomTextField(
                  passwordVisible: false,
                  labelText: '',
                  hintText: 'الوصف',
                  isPassword: false,
                  textEditingController: _bioController,
                  nextnode: TextInputAction.next, texttype: TextInputType.text,
                  checks: '',
                  isMultiline: true,
                ),
                CustomTextField(
                  passwordVisible: false,
                  labelText: '',
                  hintText: 'رقم الهاتف',
                  isPassword: false,
                  textEditingController: _phoneController,
                  nextnode: TextInputAction.next, texttype: TextInputType.text,
                  checks: '',
                ),
                CustomTextField(
                  passwordVisible: false,
                  labelText: '',
                  hintText: 'رقم الواتساب',
                  isPassword: false,
                  textEditingController: _whatsappController,
                  nextnode: TextInputAction.done, texttype: TextInputType.text,
                  checks: '',
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(backgroundColor),
                  ),
                  onPressed: _isLoading ? null : updateProfile,
                  child: _isLoading
                      ? CircularProgressIndicator(color: maincolor)
                      : Text(
                          'Update Profile',
                          style: TextStyle(color: maincolor),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
