import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class JordanPhoneNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String text;

  const JordanPhoneNumberInput({required this.controller, required this.text});

  @override
  _JordanPhoneNumberInputState createState() => _JordanPhoneNumberInputState();
}

class _JordanPhoneNumberInputState extends State<JordanPhoneNumberInput> {
  TextEditingController phoneController = TextEditingController();
  String? _validationError;

  @override
  void initState() {
    super.initState();
    widget.controller.text = '+962';
    //phoneController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // phoneController.removeListener(_onTextChanged);
    phoneController.dispose();
    super.dispose();
  }

  // void _onTextChanged() {
  //   widget.controller.text = phoneController.text;
  //   _validatePhoneNumber();
  // }

  bool _validatePhoneNumber() {
    String phoneNumber = widget.controller.text.trim();
    if (phoneNumber.isEmpty) {
      _validationError = 'Phone number is required';
      return false;
    } else if (!phoneNumber.startsWith('77') &&
        !phoneNumber.startsWith('78') &&
        !phoneNumber.startsWith('79')) {
      _validationError = 'Phone number must start with 77, 78, or 79';
      return false;
    } else if (phoneNumber.length != 13) {
      _validationError = 'Invalid phone number length';
      return false;
    } else {
      _validationError = null;
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntlPhoneField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: widget.text,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 208, 208, 208).withOpacity(0.5),
                hintStyle: TextStyle(color: Colors.black),
                alignLabelWithHint: false,
              ),
              initialCountryCode: 'JO',
              dropdownIcon: Icon(Icons.arrow_drop_down),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              validator: (phone) {
                if (_validatePhoneNumber()) {
                  return null;
                } else {
                  return _validationError;
                }
              },
              onChanged: (phone) {
                widget.controller.text = phone.completeNumber;
                _validatePhoneNumber();
              },
              onSaved: (phone) {
                widget.controller.text = phone!.completeNumber;
                _validatePhoneNumber();
              },
              cursorColor: Colors.black,
              // textStyle: TextStyle(color: Colors.black),
              keyboardType: TextInputType.phone,
            ),
            if (_validationError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _validationError!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
