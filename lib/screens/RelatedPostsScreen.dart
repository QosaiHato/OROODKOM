import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/SmallPostCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SortOption { lowToHigh, highToLow, lowToHighRate, highToLowRate }

class RelatedPostsScreen extends StatefulWidget {
  final String query;
  final String whereToSearch;

  RelatedPostsScreen({
    required this.query,
    required this.whereToSearch,
  });

  @override
  _RelatedPostsScreenState createState() => _RelatedPostsScreenState();
}

class _RelatedPostsScreenState extends State<RelatedPostsScreen> {
  List<Post>? _relatedPosts;
  SortOption _selectedSortOption = SortOption.lowToHigh;

  @override
  void initState() {
    super.initState();
    _fetchRelatedPosts();
  }

  Future<void> _fetchRelatedPosts() async {
    Query query = FirebaseFirestore.instance.collection('posts');

    // Add filters based on the provided parameters
    if (widget.query.isNotEmpty) {
      query = query.where(widget.whereToSearch,
          isGreaterThanOrEqualTo: widget.query.toLowerCase(),
          isLessThanOrEqualTo: '${widget.query.toLowerCase()}\uf8ff');
    }

    final querySnapshot = await query.get();
    List<Post> posts =
        querySnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();

    // Sort the posts based on the selected sort option
    _sortRelatedPosts(_selectedSortOption, posts);

    setState(() {
      _relatedPosts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        actions: [
          PopupMenuButton<SortOption>(
            color: backgroundColor,
            icon: Row(
              children: [
                Icon(Icons.filter_list),
                Text('Filter'),
              ],
            ),
            initialValue: _selectedSortOption,
            onSelected: (value) {
              setState(() {
                _selectedSortOption = value;
              });
              _sortRelatedPosts(value, _relatedPosts!);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
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
          SizedBox(
            width: 25,
          ),
        ],
      ),
      body: _relatedPosts == null
          ? Center(child: CircularProgressIndicator())
          : _relatedPosts!.isEmpty
              ? Center(
                  child: Text(
                    'لا يوجد منشورات تطابق يحثك',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _relatedPosts!.length ~/ 2 +
                      (_relatedPosts!.length % 2 == 0 ? 0 : 1),
                  itemBuilder: (context, index) {
                    final int firstIndex = index * 2;
                    final int secondIndex = firstIndex + 1;
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child:
                                SmallPostCard(post: _relatedPosts![firstIndex]),
                          ),
                        ),
                        if (secondIndex < _relatedPosts!.length)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: SmallPostCard(
                                  post: _relatedPosts![secondIndex]),
                            ),
                          ),
                      ],
                    );
                  },
                ),
    );
  }

  void _sortRelatedPosts(SortOption sortOption, List<Post> posts) {
    switch (sortOption) {
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

    setState(() {
      _relatedPosts = posts;
    });
  }
}
