import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/postCard/CustomTextView.dart';
import 'package:finalgradproj/widgets/postCard/addressTextView.dart';
import 'package:flutter/material.dart';

class PostInfo extends StatelessWidget {
  final dynamic snap;

  PostInfo({required this.snap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(Name: "اسم المنتج: ", text: snap.productName),
        CustomTextView(Name: "السعر: ", text: "${snap.price.toString()} د.أ"),
        CustomTextView(Name: "المدينة: ", text: snap.city),
        AddressCustomTextView(snap: snap.address),
      ],
    );
  }
}

class TextView extends StatelessWidget {
  final String Teext;
  final String secText;

  TextView({required this.Teext, required this.secText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          Teext,
          style: TextStyle(
              fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
        ),
        Text(
          secText,
          style: TextStyle(
              fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
