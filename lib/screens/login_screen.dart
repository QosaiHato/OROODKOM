import 'package:finalgradproj/resources/auth_methods.dart';
import 'package:finalgradproj/responsive/mobile_screen_layout.dart';
import 'package:finalgradproj/responsive/responsive_layout_screen.dart';
import 'package:finalgradproj/responsive/web_screen_layout.dart';
import 'package:finalgradproj/screens/AccountPass&mail/ForgotPasswordScreen%20.dart';
import 'package:finalgradproj/screens/SignUpPage/signup_screen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/utils/utils.dart';
import 'package:finalgradproj/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late BuildContext _scaffoldContext; // Store the context here

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == "success") {
      Navigator.of(_scaffoldContext).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            );
          },
        ),
      ).then((_) {
        // Once the feed screen is pushed and displayed, pop the login screen
        Navigator.of(_scaffoldContext).pop();
      });
    } else {
      if (res == "user not found") {
        showSnackBar("User with that email doesn't exist", _scaffoldContext);
      } else {
        showSnackBar("Login failed. Please try again.", _scaffoldContext);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  navigateToSignUp() {
    Navigator.of(_scaffoldContext).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  navigateToForgetPassScreen() {
    Navigator.of(_scaffoldContext).push(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: null,
        resizeToAvoidBottomInset: true,
        body: Builder(
          builder: (BuildContext scaffoldContext) {
            // Store the context here
            _scaffoldContext =
                scaffoldContext; // Assign it to the member variable
            return SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 64),
                      Image.asset(
                        'assets/ooffeerrss.png',
                        height: 150,
                      ),
                      const SizedBox(height: 64),
                      CustomTextField(
                        nextnode: TextInputAction.next,
                        passwordVisible: true,
                        labelText: '',
                        hintText: 'الايميل',
                        isPassword: false,
                        textEditingController: _emailController,
                        checks: 'email',
                        texttype: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        nextnode: TextInputAction.done,
                        passwordVisible: false,
                        labelText: '',
                        hintText: 'الرمز السري',
                        isPassword: true,
                        textEditingController: _passwordController,
                        checks: 'password',
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: loginUser,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: maincolor,
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: whiteColor,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: navigateToSignUp,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                "تسجيل  ",
                                style: TextStyle(
                                  color: maincolor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Text("لا تمتلك حساب؟  "),
                        ],
                      ),
                      GestureDetector(
                        onTap: navigateToForgetPassScreen,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            " نسيت الرمز السري؟",
                            style: TextStyle(
                              color: maincolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
