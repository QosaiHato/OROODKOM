import 'package:flutter/material.dart';
import 'package:finalgradproj/models/user.dart';
import 'package:finalgradproj/screens/SignUpPage/Widgets/Signup1.dart';
import 'package:finalgradproj/screens/SignUpPage/Widgets/Signup2.dart';
import 'package:finalgradproj/screens/SignUpPage/Widgets/Signup3.dart';
import 'package:finalgradproj/resources/auth_methods.dart';
import 'package:finalgradproj/responsive/mobile_screen_layout.dart';
import 'package:finalgradproj/responsive/responsive_layout_screen.dart';
import 'package:finalgradproj/responsive/web_screen_layout.dart';
import 'package:finalgradproj/screens/login_screen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/utils/utils.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _whatsAppNumberController =
      TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  bool _isRegistering = false;
  UserType _selectedUserType = UserType.normal;
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _phoneNumberController.dispose();
    _whatsAppNumberController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  void _selectBusinessProofImage(Uint8List image) {
    setState(() {
      _businessProofImage = image;
    });
  }

  void _nextPage() {
    if (_areFieldsFilled(_currentPage)) {
      if (_currentPage < 1 && _selectedUserType == UserType.normal) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        setState(() {
          _currentPage++;
        });
      } else if (_currentPage < 2 && _selectedUserType == UserType.business) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        setState(() {
          _currentPage++;
        });
      } else {
        _isRegistering = true;
        signUpUser();
      }
    } else {
      showSnackBar("Please fill in all the required fields", context);
    }
  }

  bool _areFieldsFilled(int currentPage) {
    switch (currentPage) {
      case 0:
        return _emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty &&
            _confirmPasswordController.text.isNotEmpty;
      case 1:
        return _usernameController.text.isNotEmpty &&
            _bioController.text.isNotEmpty &&
            _phoneNumberController.text.isNotEmpty &&
            (_selectedUserType == UserType.normal ||
                _whatsAppNumberController.text.isNotEmpty);
      case 2:
        return _businessNameController.text.isNotEmpty;
      default:
        return false;
    }
  }

  void _onUserTypeChanged(UserType? value) {
    if (value != null) {
      setState(() {
        _selectedUserType = value;
        _pageController.jumpToPage(0);
        _currentPage = 0;
      });
    }
  }

  Future<void> selectImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Uint8List? image = await pickImage(ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    } catch (e) {
      showSnackBar("Error selecting image: $e", context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Uint8List? _businessProofImage;

  void selectBusinessProofImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Uint8List? image = await pickImage(ImageSource.gallery);
      if (image != null) {
        setState(() {
          _businessProofImage = image;
        });
      }
    } catch (e) {
      showSnackBar("Error selecting image: $e", context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void signUpUser() async {
    try {
      setState(() {
        _isLoading = true;
        _isRegistering = true;
      });

      if (_passwordController.text != _confirmPasswordController.text) {
        showSnackBar("Passwords do not match", context);
        return;
      }

      // Check if the user type is business and ensure an image is provided
      if (_selectedUserType == UserType.business && _image == null) {
        showSnackBar(
            "Please select an image for your business profile", context);
        return;
      }
      if (_selectedUserType == UserType.business &&
          _businessProofImage == null) {
        showSnackBar("Please upload a business proof image", context);
        return;
      }

      String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        businessName: _selectedUserType == UserType.business
            ? _businessNameController.text
            : '',
        file: _image ?? Uint8List(0),
        businessProofFile: _businessProofImage ?? Uint8List(0),
        userType: _selectedUserType,
        phoneNumber: _phoneNumberController.text,
        whatsappNumber: _whatsAppNumberController.text,
      );

      if (res == 'success') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          ),
        );
      } else {
        showSnackBar(res, context);
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isRegistering = false;
      });
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: _currentPage == 0
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
          actions: [
            if (_currentPage > 0)
              TextButton(
                  onPressed: _previousPage,
                  child: Text(
                    "Step back",
                    style: TextStyle(color: maincolor),
                  ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Signup1(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      selectedUserType: _selectedUserType,
                      onUserTypeChanged: _onUserTypeChanged,
                    ),
                    Signup2(
                      usernameController: _usernameController,
                      bioController: _bioController,
                      phoneNumberController: _phoneNumberController,
                      whatsAppNumberController: _whatsAppNumberController,
                      selectedUserType: _selectedUserType,
                      selectImage: selectImage,
                      image: _image,
                      isLoading: _isLoading,
                    ),
                    if (_selectedUserType == UserType.business)
                      Signup3(
                        businessNameController: _businessNameController,
                        selectedUserType: _selectedUserType,
                        onRegister: signUpUser,
                        onBusinessProofImagePicked: _selectBusinessProofImage,
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: navigateToLogin,
                    child: const Text(
                      'Already have an account? Log in',
                      style: TextStyle(color: maincolor),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        iconColor: WidgetStatePropertyAll(whiteColor)),
                    onPressed: _nextPage,
                    child: _isRegistering
                        ? const CircularProgressIndicator()
                        : Text(
                            style: TextStyle(color: maincolor),
                            (_currentPage == 1 &&
                                        _selectedUserType == UserType.normal) ||
                                    (_currentPage == 2 &&
                                        _selectedUserType == UserType.business)
                                ? 'Register'
                                : 'Next',
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
