import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalgradproj/screens/ProfileScreen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').get();
    List<Map<String, dynamic>> users =
        snapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      this.users = users;
    });
  }

  Future<void> _searchUsers(String query) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    List<Map<String, dynamic>> users =
        snapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      this.users = users;
    });
  }

  Future<void> _deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
    _getAllUsers(); // Refresh the list of users
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            _searchUsers(value);
          },
          decoration: InputDecoration(
            hintText: 'Search users',
            border: InputBorder.none,
          ),
        ),
      ),
      body: users.isEmpty
          ? Center(
              child: Text('No users found'),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return GestureDetector(
                  onLongPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: user['uid'],
                        //currentUserUid: currentUserId,
                      ),
                    ));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['photoUrl']),
                    ),
                    title: Text(user['username']),
                    subtitle: Text(user['uid']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: mainColor),
                      onPressed: () {
                        _deleteUser(user['uid']);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
