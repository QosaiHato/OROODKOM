import 'package:finalgradproj/functions/phoneNumberCheck.dart';
import 'package:finalgradproj/functions/validationFunctions/BioCheck.dart';
import 'package:finalgradproj/functions/validationFunctions/CheckPassword.dart';
import 'package:finalgradproj/functions/validationFunctions/checkEmail.dart';
import 'package:finalgradproj/functions/validationFunctions/userNameCheck.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final bool passwordVisible;
  final String labelText;
  final String hintText;
  final bool isPassword;
  final bool isMultiline;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onsubmitted;
  final TextEditingController textEditingController;
  final ValueChanged<String>? onSubmitted;
  final String checks;
  final bool noNeedToCheck;
  final bool isLogin;
  final TextInputType texttype;
  final TextInputAction nextnode;

  const CustomTextField({
    Key? key,
    this.passwordVisible = true,
    this.onSubmitted,
    required this.labelText,
    required this.hintText,
    this.isPassword = false,
    this.isMultiline = false,
    required this.textEditingController,
    this.checks = "",
    this.noNeedToCheck = false,
    required this.nextnode,
    this.isLogin = false,
    this.onChanged,
    this.texttype = TextInputType.none,
    this.onsubmitted,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.passwordVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onFieldSubmitted: (value) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(value); // Call onSubmitted callback
          }
          FocusScope.of(context).unfocus(); // Close the keyboard
        },
        strutStyle: StrutStyle(height: 0.5),
        cursorColor: maincolor,
        cursorErrorColor: Colors.red,
        style: TextStyle(color: textColor),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty && widget.noNeedToCheck == 0) {
            return "Please enter correct information";
          } else if (widget.checks == 'email') {
            return CheckEmail(value);
          } else if (widget.checks == 'password' && !widget.isLogin) {
            String result = CheckPassword(value);
            return result.isNotEmpty ? result : null;
          } else if (widget.checks == 'username') {
            return CheckUsername(value);
          } else if (widget.checks == 'bio') {
            return CheckBio(value);
          } else if (widget.texttype == TextInputType.phone) {
            String phoneNumber =
                "+962${value.startsWith('7') ? value : '7$value'}";
            if (!validatePhoneNumber(phoneNumber)) {
              return "Please enter a valid phone number starting with 77, 78, or 79";
            }
            return null;
          }
          return null;
        },
        controller: widget.textEditingController,
        obscureText: widget.isPassword ? !_isPasswordVisible : false,
        maxLines: widget.isMultiline ? null : 1,
        decoration: InputDecoration(
          fillColor: Color.fromARGB(255, 208, 208, 208).withOpacity(0.5),
          helperStyle: TextStyle(color: textColor),
          hintStyle: TextStyle(color: textColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          errorStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red.withOpacity(0.5),
          ),
          hintText: widget.hintText,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          alignLabelWithHint: false,
          filled: true,
        ),
        keyboardType:
            widget.isPassword ? TextInputType.visiblePassword : widget.texttype,
        textInputAction: widget.nextnode,
        onChanged: widget.onChanged,
      ),
    );
  }
}
