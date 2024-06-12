import 'package:finalgradproj/widgets/CustomTextField.dart';
import 'package:finalgradproj/widgets/phoneNumberfield.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:finalgradproj/models/user.dart';

import 'package:finalgradproj/utils/colors.dart';

class Signup2 extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController bioController;
  final TextEditingController phoneNumberController;
  final TextEditingController whatsAppNumberController;
  final UserType selectedUserType;
  final VoidCallback selectImage;
  final Uint8List? image;
  final bool isLoading;

  const Signup2({
    Key? key,
    required this.usernameController,
    required this.bioController,
    required this.phoneNumberController,
    required this.whatsAppNumberController,
    required this.selectedUserType,
    required this.selectImage,
    required this.image,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            labelText: 'Username',
            hintText: 'Enter your username',
            textEditingController: usernameController,
            checks: 'username',
            texttype: TextInputType.text,
            nextnode: TextInputAction.next,
          ),
          CustomTextField(
            labelText: 'Bio',
            hintText: 'Enter your bio',
            isMultiline: true,
            textEditingController: bioController,
            checks: 'bio',
            texttype: TextInputType.multiline,
            nextnode: TextInputAction.next,
          ),
          // CustomTextField(
          //   labelText: 'Phone Number',
          //   hintText: 'Enter your phone number',
          //   textEditingController: phoneNumberController,
          //   texttype: TextInputType.phone,
          //   nextnode: TextInputAction.next,
          // ),
          JordanPhoneNumberInput(
            controller: phoneNumberController,
            text: "رقم الهاتف",
          ),
          if (selectedUserType == UserType.business)
            JordanPhoneNumberInput(
              controller: whatsAppNumberController,
              text: "رقم الواتساب",
            ),
          // CustomTextField(
          //   labelText: 'WhatsApp Number',
          //   hintText: 'Enter your WhatsApp number',
          //   textEditingController: whatsAppNumberController,
          //   texttype: TextInputType.phone,
          //   nextnode: TextInputAction.done,
          // ),
          const SizedBox(height: 20),
          if (selectedUserType == UserType.business) ...[
            const Text('Profile Picture:'),
            isLoading
                ? const CircularProgressIndicator()
                : GestureDetector(
                    onTap: selectImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: maincolor,
                      child: image == null
                          ? const Icon(Icons.add_a_photo, color: Colors.white)
                          : ClipOval(
                              child: Image.memory(
                                image!,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                    ),
                  ),
          ],
        ],
      ),
    );
  }
}
