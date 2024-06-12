import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:finalgradproj/utils/colors.dart';

class CustomsButton extends StatelessWidget {
  final Function()? function;
  final Function(bool)? onhover;
  final Color backgroundColor;
  final Color borderColor;
  final double width;
  final double height;
  final String text;
  final Color textColor;
  final Icon icon;

  const CustomsButton({
    Key? key,
    required this.function,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.textColor,
    required this.icon,
    this.width = 0.4, // Percentage of screen width
    required this.height,
    this.onhover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final actualWidth = screenWidth * width;

    return TextButton(
      onHover: onhover,
      onPressed: function,
      child: Container(
        width: actualWidth,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: lightgrayColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  "$text   ",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
