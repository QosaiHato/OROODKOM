import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/utils/global_variables.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: Image.asset("assets/offers.png",
              color: PPrimaryColor, height: 32),
          actions: [
            IconButton(
              onPressed: () => navigationTapped(0),
              icon: Icon(
                Icons.home,
                color: _page == 0 ? PPrimaryColor : secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navigationTapped(1),
              icon: Icon(
                Icons.search,
                color: _page == 1 ? PPrimaryColor : secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navigationTapped(2),
              icon: Icon(
                Icons.add_a_photo,
                color: _page == 2 ? PPrimaryColor : secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navigationTapped(3),
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? PPrimaryColor : secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => navigationTapped(4),
              icon: Icon(
                Icons.person,
                color: _page == 4 ? PPrimaryColor : secondaryColor,
              ),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: homeScreenItems,
        ));
  }
}
