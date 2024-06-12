import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  TextView({super.key, required this.Teext, required this.secText});
  String Teext;
  String secText;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.right,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      TextSpan(children: [TextSpan(text: Teext), TextSpan(text: secText)]),
    );
  }
}
