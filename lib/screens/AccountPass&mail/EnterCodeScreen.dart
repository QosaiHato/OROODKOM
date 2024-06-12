import 'package:finalgradproj/screens/login_screen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter/material.dart';

class EnterCodeScreen extends StatelessWidget {
  final String email;
  final TextEditingController _codeController = TextEditingController();

  EnterCodeScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'A verification code has been sent to $email.',
                  textAlign: TextAlign.center,
                ),
                Text('Check your email')
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(whiteColor),
                  textStyle:
                      MaterialStatePropertyAll(TextStyle(color: maincolor))),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text(
                'Back to login',
                style: TextStyle(color: maincolor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
