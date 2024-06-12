// custom_bottom_nav_bar.dart

import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: lightgrayColor.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: CupertinoTabBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                FluentIcons.home_20_filled,
                color: (currentIndex == 0) ? maincolor : lightgrayColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FluentIcons.search_24_filled,
                color: (currentIndex == 1) ? maincolor : lightgrayColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FluentIcons.person_28_filled,
                color: (currentIndex == 2) ? maincolor : lightgrayColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
