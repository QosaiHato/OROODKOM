import 'package:finalgradproj/models/user.dart' as model;
import 'package:finalgradproj/providers/ScrollControllerProvider%20.dart';
import 'package:finalgradproj/screens/AdminScreens/AdminDash.dart';
import 'package:finalgradproj/screens/CategoryScreen.dart';
import 'package:finalgradproj/screens/feed_screen.dart';
import 'package:finalgradproj/screens/ProfileScreen/profile_screen.dart';
import 'package:finalgradproj/screens/search_screen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:provider/provider.dart';

const webScreenSize = 600;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _currentIndex = 0;
  List<Widget Function()>? _screens;
  late ScrollControllerProvider scrollProvider;
  late model.User _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserDetails();
  }

  Future<void> _fetchCurrentUserDetails() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      setState(() {
        _currentUser = model.User.fromSnap(userDoc);
        _setScreens();
      });
    } catch (e) {
      print('Error fetching current user details: $e');
    }
  }

  void _setScreens() {
    if (_currentUser.userType == model.UserType.business) {
      _screens = [
        () => FeedScreen(),
        () => SearchScreen(),
        () => CategoryScreen(),
        () => ProfileScreen(
              uid: FirebaseAuth.instance.currentUser!.uid,
              appbar: false,
            )
      ];
    } else if (_currentUser.userType == model.UserType.admin) {
      _screens = [
        () => FeedScreen(),
        () => SearchScreen(),
        () => CategoryScreen(),
        () => AdminDashboard(),
        () => ProfileScreen(
              uid: FirebaseAuth.instance.currentUser!.uid,
              appbar: false,
            ),
      ];
    } else {
      _screens = [
        () => FeedScreen(),
        () => SearchScreen(),
        () => CategoryScreen(),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_screens == null || _currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ChangeNotifierProvider<ScrollControllerProvider>(
      create: (_) => ScrollControllerProvider(),
      child: Builder(
        builder: (context) {
          scrollProvider =
              Provider.of<ScrollControllerProvider>(context, listen: false);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: _screens![_currentIndex](),
              bottomNavigationBar: Directionality(
                textDirection: TextDirection.rtl,
                child: SalomonBottomBar(
                  currentIndex: _currentIndex,
                  onTap: _onItemTapped,
                  items: [
                    SalomonBottomBarItem(
                      icon: Icon(FluentIcons.home_24_regular),
                      title: Text("Home"),
                      selectedColor: CupertinoColors.activeBlue,
                    ),
                    SalomonBottomBarItem(
                      icon: Icon(FluentIcons.search_24_regular),
                      title: Text("Search"),
                      selectedColor: CupertinoColors.activeBlue,
                    ),
                    SalomonBottomBarItem(
                      icon: Icon(FluentIcons.list_16_filled),
                      title: Text("Categories"),
                      selectedColor: CupertinoColors.activeBlue,
                    ),
                    if (_currentUser.userType == model.UserType.admin)
                      SalomonBottomBarItem(
                        icon: Icon(FluentIcons.options_16_filled),
                        title: Text("Dashboard"),
                        selectedColor: CupertinoColors.activeBlue,
                      ),
                    if ((_currentUser.userType == model.UserType.business &&
                            _currentUser?.verificationStatus ==
                                model.VerificationStatus.approved) ||
                        _currentUser.userType == model.UserType.admin)
                      SalomonBottomBarItem(
                        icon: Icon(FluentIcons.person_24_regular),
                        title: Text("Profile"),
                        selectedColor: CupertinoColors.activeBlue,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
