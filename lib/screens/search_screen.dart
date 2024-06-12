import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/providers/ScrollControllerProvider%20.dart';

import 'package:finalgradproj/screens/RelatedPostsScreen.dart';
import 'package:finalgradproj/screens/post_card.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/Image&Price.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

enum SortOption { lowToHigh, highToLow, lowToHighRate, highToLowRate }

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Post> _posts = [];
  SortOption _selectedSortOption = SortOption.lowToHigh;
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  bool _mounted = true;
  @override
  void initState() {
    super.initState();
    final scrollProvider =
        Provider.of<ScrollControllerProvider>(context, listen: false);
    scrollProvider.scrollController.addListener(scrollProvider.onScroll);
    _fetchPosts();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<void> _fetchPosts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    List<Post> posts =
        querySnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();

    // Sort the posts by price (low to high) by default
    posts.sort((a, b) => a.price.compareTo(b.price));
    if (_mounted) {
      setState(() {
        _posts = posts;
      });
    }
  }

  Future<void> _searchPosts(String query) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('posts')
        .where('productName', isGreaterThanOrEqualTo: query)
        .where('productName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    List<Post> posts =
        querySnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();

    // Sort the posts based on the selected sort option
    _sortPosts(posts);

    setState(() {
      _posts = posts;
    });
  }

  void _sortPosts(List<Post> posts) {
    switch (_selectedSortOption) {
      case SortOption.lowToHigh:
        posts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.highToLow:
        posts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.lowToHighRate:
        posts.sort((a, b) => a.averageRating.compareTo(b.averageRating));
        break;
      case SortOption.highToLowRate:
        posts.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
    }
  }

  Future<void> _refreshGridView() async {
    // Simulate loading delay
    await Future.delayed(Duration(seconds: 1));

    // Reload data and rebuild the UI
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<SortOption>(
              color: backgroundColor,
              icon: Row(
                children: [
                  Icon(Icons.filter_list),
                  SizedBox(width: 8.0),
                  Text('Filter'),
                ],
              ),
              initialValue: _selectedSortOption,
              onSelected: (value) {
                setState(() {
                  _selectedSortOption = value;
                });
                _sortPosts(_posts);
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SortOption>>[
                PopupMenuItem<SortOption>(
                  value: SortOption.lowToHigh,
                  child: Text(
                    'Sort by Price: Low to High',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.highToLow,
                  child: Text(
                    'Sort by Price: High to Low',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.lowToHighRate,
                  child: Text(
                    'Sort by Rate: Low to High',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.highToLowRate,
                  child: Text(
                    'Sort by Rate: High to Low',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ],
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: backgroundColor,
          elevation: 0,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'البحث عن منتج',
              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
              filled: true,
              fillColor: lightgrayColor.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _fetchPosts();
                      },
                    )
                  : null,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (query) {
              // Navigate to RelatedPostsScreen when submitted
              print(query);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RelatedPostsScreen(
                    query: query,
                    whereToSearch: 'productName',
                  ),
                ),
              );
            },
            onChanged: (query) {
              if (query.isNotEmpty) {
                _searchPosts(query);
              } else {
                _fetchPosts();
              }
            },
          ),
        ),
        body: RefreshIndicator(
          color: maincolor,
          onRefresh: _refreshGridView,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              children: _posts.map((post) {
                return GestureDetector(
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
                  child: ImageAndPrice(post: post),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
