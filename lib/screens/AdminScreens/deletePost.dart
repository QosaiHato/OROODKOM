import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/screens/post_card.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class DeletePostPage extends StatefulWidget {
  @override
  _DeletePostPageState createState() => _DeletePostPageState();
}

class _DeletePostPageState extends State<DeletePostPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Post> _posts = [];
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    _getAllPosts();
  }

  Future<void> _getAllPosts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('posts').get();
    List<Post> posts = snapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
    setState(() {
      _posts = posts;
    });
  }

  Future<void> _searchPosts(String query) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('posts')
        .where('productName', isGreaterThanOrEqualTo: query)
        .where('productName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    List<Post> posts = snapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
    setState(() {
      _posts = posts;
    });
  }

  Future<void> _deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
    _getAllPosts(); // Refresh the list of posts
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
            _searchPosts(value);
          },
          decoration: InputDecoration(
            hintText: 'Search posts',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _posts.isEmpty
          ? Center(
              child: Text('No posts found'),
            )
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(
                                  leading: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(FeatherIcons.arrowRight),
                                  ),
                                ),
                                body: ListView(children: [
                                  PostCard(
                                    snap: post,
                                    currentUserUid: currentUserUid,
                                  ),
                                ]),
                              )));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      child: post.postUrls!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                post.postUrls![0],
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Center(
                                child: Text(
                                  post.productName.substring(0, 1),
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                    ),
                  ),
                  title: Text(post.productName),
                  subtitle: Text('JD ${post.price}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: mainColor),
                    onPressed: () {
                      _deletePost(post.postId);
                    },
                  ),
                );
              },
            ),
    );
  }
}
