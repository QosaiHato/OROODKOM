import 'package:finalgradproj/models/user.dart';
import 'package:finalgradproj/screens/AdminScreens/deletePost.dart';
import 'package:finalgradproj/screens/AdminScreens/deleteuser.dart';
import 'package:finalgradproj/screens/ProfileScreen/profile_screen.dart';

import 'package:finalgradproj/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalgradproj/resources/auth_methods.dart';

// Admin Dashboard Widget
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PageController _pageController = PageController();
  List<User> businessUsers = [];
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchBusinessUsers();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> fetchBusinessUsers() async {
    setState(() {
      isLoading = true;
    });

    // Fetch all pending business users from Firestore
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('userType', isEqualTo: 'business')
        .where('verificationStatus', isEqualTo: 'pending')
        .get();

    setState(() {
      businessUsers = snapshot.docs.map((doc) => User.fromSnap(doc)).toList();
      isLoading = false;
    });
  }

  void approveUser(String uid) async {
    // Call the updateUserVerification method to approve the user
    await AuthMethods()
        .updateUserVerification(uid, VerificationStatus.approved);

    // Refetch the pending business users
    await fetchBusinessUsers();
  }

  void rejectUser(String uid) async {
    // Call the updateUserVerification method to reject the user
    await AuthMethods()
        .updateUserVerification(uid, VerificationStatus.rejected);

    // Refetch the pending business users
    await fetchBusinessUsers();
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Admin Dashboard'),
        bottom: TabBar(
          labelColor: maincolor,
          indicatorColor: maincolor,
          controller: _tabController,
          tabs: [
            Tab(text: 'طلبات المحلات'),
            Tab(text: 'حذف مستخدم'),
            Tab(text: 'حذف منشور'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            color: mainColor,
            onRefresh: fetchBusinessUsers,
            child: ListView.builder(
              itemCount: businessUsers.length,
              itemBuilder: (context, index) {
                User user = businessUsers[index];
                return GestureDetector(
                  onLongPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: user.uid,
                        //currentUserUid: currentUserId,
                      ),
                    ));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    title: Text(user.username),
                    subtitle: Text(user.verificationStatus.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (user.verificationStatus ==
                            VerificationStatus.pending)
                          IconButton(
                            onPressed: () => approveUser(user.uid),
                            icon: Icon(Icons.check),
                          ),
                        if (user.verificationStatus ==
                            VerificationStatus.pending)
                          IconButton(
                            onPressed: () => rejectUser(user.uid),
                            icon: Icon(Icons.close),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          DeleteUserPage(),
          DeletePostPage(),
        ],
      ),
      // Show a loading indicator if isLoading is true
      floatingActionButton: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            )
          : null,
    );
  }
}
