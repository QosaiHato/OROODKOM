import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/models/user.dart' as model;
import 'package:finalgradproj/providers/user_provider.dart';
import 'package:finalgradproj/resources/auth_methods.dart';
import 'package:finalgradproj/screens/ProfileScreen/EditProfileScreen.dart';
import 'package:finalgradproj/screens/login_screen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/utils/utils.dart';
import 'package:finalgradproj/widgets/CustomsButton.dart';
import 'package:finalgradproj/widgets/SmallPostCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ionicons/ionicons.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final bool appbar;
  ProfileScreen({Key? key, required this.uid, this.appbar = true})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  model.User? usertype;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>> _fetchProfileData() async {
    try {
      // Fetch user data using UserProvider
      await Provider.of<UserProvider>(context, listen: false)
          .refreshUser(uid: widget.uid);
      model.User? usser =
          Provider.of<UserProvider>(context, listen: false).getUser;

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      int postLen = postSnap.docs.length;

      List<Post> posts =
          postSnap.docs.map((doc) => Post.fromSnap(doc)).toList();

      return {
        'otherUser': usser,
        'postLen': postLen,
        'posts': posts,
      };
    } catch (e, stackTrace) {
      print('Error fetching profile data: $e');
      print('Stack trace: $stackTrace');
      return {
        'otherUser': null,
        'postLen': 0,
        'posts': [],
      };
    }
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 200).floor();
    return crossAxisCount;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    model.User? usserr =
        Provider.of<UserProvider>(context, listen: false).getUser;
    double containerHeight = 100;
    double containerWidth = 100;
    double heightInMediaQuery = (containerHeight / 100) * screenSize.height;
    double widthInMediaQuery = (containerWidth / 100) * screenSize.width;

    return Theme(
      data: ThemeData(scaffoldBackgroundColor: backgroundColor),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: widget.appbar
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(FeatherIcons.arrowRight))
              : null,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  FeatherIcons.settings,
                  color: maincolor,
                  size: 24.0,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('Edit Profile'),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text(
                                  'Log Out',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () async {
                                  await AuthMethods().signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _fetchProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: maincolor,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data!;
            final otherUser = data['otherUser'] as model.User?;
            final posts = data['posts'] as List<Post>;

            if (otherUser != null) {
              usertype = otherUser;
            }

            return RefreshIndicator(
              color: maincolor,
              onRefresh: _fetchProfileData,
              child: ListView(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 25),
                      otherUser != null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(otherUser.photoUrl),
                              radius: 40,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: AssetImage('assets/person.png'),
                              radius: 40,
                            ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            otherUser?.username ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: darkColor,
                            ),
                          ),
                          if (usertype != null &&
                              usertype!.userType == model.UserType.admin)
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  FeatherIcons.code,
                                  color: maincolor,
                                ),
                              ],
                            )
                          else
                            SizedBox()
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(otherUser?.bio ?? ''),
                      SizedBox(height: 30),
                      // if (otherUser!.uid != currentUserId &&
                      //     usertype == model.UserType.admin )
                      // CustomsButton(
                      //   width: 0.4, // 40% of screen width
                      //   height: 40,
                      //   text: "حذف الحساب",
                      //   backgroundColor: backgroundColor,
                      //   textColor: textColor,
                      //   borderColor: lightgrayColor,
                      //   icon: Icon(
                      //     Ionicons.close,
                      //     color: Colors.red,
                      //     size: 24,
                      //   ),
                      //   onhover: (p) {},
                      //   function: () {
                      //     showModalBottomSheet(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return Container(
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(15.0),
                      //             color: Colors.white,
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 ListTile(
                      //                   title: Text(
                      //                     'حذف الحساب',
                      //                     style: TextStyle(
                      //                         color: Colors.red,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                   onTap: () async {
                      //                     await AuthMethods()
                      //                         .deleteUser(otherUser.uid);
                      //                     showSnackBar(
                      //                         "Account Deleted", context);
                      //                   },
                      //                 ),
                      //                 ListTile(
                      //                   title: Text(
                      //                     'cancle',
                      //                     style: TextStyle(
                      //                         color: textColor,
                      //                         fontWeight: FontWeight.w500),
                      //                   ),
                      //                   onTap: () {
                      //                     Navigator.pop(context);
                      //                   },
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomsButton(
                                width: 0.4, // 40% of screen width
                                height: 40,
                                text: otherUser!.phoneNumber ?? "غير متوفر",
                                backgroundColor: backgroundColor,
                                textColor: textColor,
                                borderColor: lightgrayColor,
                                icon: Icon(
                                  Ionicons.logo_whatsapp,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                onhover: (p) {},
                                function: () {
                                  _launchWhatsApp(
                                    context,
                                    otherUser.phoneNumber ?? "غير متوفر",
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: CustomsButton(
                                width: 0.4, // 40% of screen width
                                height: 40,
                                text: otherUser.phoneNumber ?? "غير متوفر",
                                backgroundColor: backgroundColor,
                                textColor: textColor,
                                borderColor: lightgrayColor,
                                icon: Icon(
                                  FeatherIcons.phone,
                                  color: maincolor,
                                  size: 16,
                                ),
                                onhover: (p) {},
                                function: () {
                                  _launchPhoneDialer(
                                    context,
                                    "${otherUser.phoneNumber ?? "لا يوجد رقم"}",
                                  );
                                  _copyToClipboard(
                                    context,
                                    "${otherUser.phoneNumber ?? "لا يوجد رقم"}",
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: posts.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: lightgrayColor.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Posts",
                                            style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Icon(FluentIcons
                                              .square_multiple_16_filled),
                                          SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: (posts.length ~/ 2) +
                                          (posts.length % 2 == 0 ? 0 : 1),
                                      itemBuilder: (context, index) {
                                        final int firstIndex = index * 2;
                                        final int secondIndex = firstIndex + 1;
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Handle onTap for the first post
                                                    // Example: navigate to post details screen
                                                  },
                                                  child: SmallPostCard(
                                                      post: posts[firstIndex]),
                                                ),
                                              ),
                                            ),
                                            if (secondIndex < posts.length)
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Handle onTap for the second post
                                                      // Example: navigate to post details screen
                                                    },
                                                    child: SmallPostCard(
                                                        post:
                                                            posts[secondIndex]),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        "No posts yet",
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ الرقم $text '),
      ),
    );
  }

  Future<void> _launchPhoneDialer(
      BuildContext context, String phoneNumber) async {
    if (phoneNumber == "غير متوفر") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No phone number available')),
      );
      return;
    }

    final telUrl = 'tel:$phoneNumber';
    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String phoneNumber) async {
    if (phoneNumber == "غير متوفر") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No WhatsApp number available')),
      );
      return;
    }

    final whatsappUrl = 'https://wa.me/$phoneNumber';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }
}
