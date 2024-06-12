import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:finalgradproj/utils/colors.dart';

class AddressCustomTextView extends StatelessWidget {
  final String snap;

  AddressCustomTextView({required this.snap});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: lightgrayColor.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Expandable(
            collapsed: _buildCollapsed(context),
            expanded: _buildExpanded(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsed(BuildContext context) {
    return ExpandableButton(
      theme: ExpandableThemeData(),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'العنوان:',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' $snap',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: maincolor),
          ],
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return ExpandableButton(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'العنوان:',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: ' $snap',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.keyboard_arrow_up, color: maincolor),
            ),
          ],
        ),
      ),
    );
  }
}
