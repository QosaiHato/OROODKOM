import 'package:finalgradproj/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:finalgradproj/models/user.dart';
import 'package:finalgradproj/utils/colors.dart';

class Signup1 extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final UserType selectedUserType;
  final ValueChanged<UserType?> onUserTypeChanged;

  const Signup1({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.selectedUserType,
    required this.onUserTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            labelText: 'Email',
            hintText: 'Enter your email',
            textEditingController: emailController,
            checks: 'email',
            texttype: TextInputType.emailAddress,
            nextnode: TextInputAction.next,
          ),
          CustomTextField(
            labelText: 'Password',
            hintText: 'Enter your password',
            isPassword: true,
            passwordVisible: false,
            textEditingController: passwordController,
            checks: 'password',
            texttype: TextInputType.visiblePassword,
            nextnode: TextInputAction.next,
          ),
          CustomTextField(
            labelText: 'Confirm Password',
            hintText: 'Confirm your password',
            isPassword: true,
            passwordVisible: false,
            textEditingController: confirmPasswordController,
            texttype: TextInputType.visiblePassword,
            nextnode: TextInputAction.done,
          ),
          const SizedBox(height: 20),
          const Text('Select User Type:'),
          RadioListTile<UserType>(
            fillColor: WidgetStatePropertyAll(maincolor),
            title: const Text('Normal User'),
            value: UserType.normal,
            groupValue: selectedUserType,
            onChanged: onUserTypeChanged,
          ),
          RadioListTile<UserType>(
            fillColor: WidgetStatePropertyAll(maincolor),
            title: const Text('Business User'),
            value: UserType.business,
            groupValue: selectedUserType,
            onChanged: onUserTypeChanged,
          ),
        ],
      ),
    );
  }
}
