import 'dart:async';

import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/models/user.dart' as model;
import 'package:finalgradproj/providers/user_provider.dart';
import 'package:finalgradproj/resources/auth_methods.dart';
import 'package:finalgradproj/screens/ProfileScreen/EditProfileScreen.dart';
import 'package:finalgradproj/screens/login_screen.dart';
import 'package:finalgradproj/screens/post_card.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/AddPost/SelectImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final ScrollController _scrollController;
  bool _isLoadingInitialData = true;
  bool _isLoadingMoreData = false;
  bool _isRefreshing = false;

  double _minPrice = 0;
  double _maxPrice = 1000;
  double _minAverageRating = 0;
  double _maxAverageRating = 5;

  double _previousMinPrice = 0;
  double _previousMaxPrice = 1000;
  double _previousMinAverageRating = 0;
  double _previousMaxAverageRating = 5;
  SortOption _selectedSortOption = SortOption.datePublishedDesc;
  SortOption _previousSortOption = SortOption.datePublishedDesc;

  List<Post> _posts = [];
  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;
  final int _pageSize = 10;
  model.User? _currentUser;
  bool _mounted = true;
  late Timer _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _debounce = Timer(Duration(milliseconds: 1500), () {});
    _fetchCurrentUserDetails();
    _fetchInitialPosts();
  }

  @override
  void dispose() {
    _mounted = false;
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_isLoadingMoreData &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      if (_debounce.isActive) {
        _debounce.cancel();
      }
      _debounce = Timer(Duration(milliseconds: 500), () {
        _loadMorePosts();
      });
    }
  }

  Future<void> _fetchInitialPosts() async {
    try {
      setState(() {
        _isLoadingInitialData = true;
      });

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('posts')
          .orderBy(_getSortField(), descending: _isDescending());

      if (_minPrice > 0 || _maxPrice < 1000) {
        query = query.where('price', isGreaterThanOrEqualTo: _minPrice);
        query = query.where('price', isLessThanOrEqualTo: _maxPrice);
      }

      if (_minAverageRating > 0 || _maxAverageRating < 5) {
        query = query.where('averageRating',
            isGreaterThanOrEqualTo: _minAverageRating);
        query = query.where('averageRating',
            isLessThanOrEqualTo: _maxAverageRating);
      }

      query = query.limit(_pageSize);

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await query.get();

      if (_mounted) {
        setState(() {
          _posts = querySnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
          _lastDocument =
              querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
          _isLoadingInitialData = false;
        });
      }
    } catch (e) {
      print('Error fetching initial posts: $e');
      if (_mounted) {
        setState(() {
          _isLoadingInitialData = false;
        });
      }
    } finally {
      if (_mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMoreData || _lastDocument == null) return;

    setState(() {
      _isLoadingMoreData = true;
    });

    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('posts')
          .orderBy(_getSortField(), descending: _isDescending());

      if (_minPrice > 0 || _maxPrice < 1000) {
        query = query.where('price', isGreaterThanOrEqualTo: _minPrice);
        query = query.where('price', isLessThanOrEqualTo: _maxPrice);
      }

      if (_minAverageRating > 0 || _maxAverageRating < 5) {
        query = query.where('averageRating',
            isGreaterThanOrEqualTo: _minAverageRating);
        query = query.where('averageRating',
            isLessThanOrEqualTo: _maxAverageRating);
      }

      query = query.startAfterDocument(_lastDocument!).limit(_pageSize);

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await query.get();

      final List<Post> newPosts =
          querySnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();

      setState(() {
        _posts.addAll(newPosts);
        _lastDocument =
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
        _isLoadingMoreData = false;
      });
    } catch (e) {
      print('Error fetching more posts: $e');
      setState(() {
        _isLoadingMoreData = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    _isRefreshing = true;
    await _fetchInitialPosts();
  }

  Future<void> _fetchCurrentUserDetails() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      setState(() {
        _currentUser = userProvider.getUser;
      });

      print('Current user: $_currentUser');
    } catch (e) {
      print('Error fetching current user details: $e');
      if (mounted) {
        setState(() {
          _currentUser = null;
        });
      }
    }
  }

  String _getSortField() {
    switch (_selectedSortOption) {
      case SortOption.lowToHigh:
        return 'price';
      case SortOption.highToLow:
        return 'price';
      case SortOption.lowToHighRate:
        return 'averageRating';
      case SortOption.highToLowRate:
        return 'averageRating';
      default:
        return 'datePublished';
    }
  }

  bool _isDescending() {
    return _selectedSortOption == SortOption.highToLow ||
        _selectedSortOption == SortOption.highToLowRate ||
        _selectedSortOption == SortOption.datePublishedDesc;
  }

  void _applyFilter() {
    bool filtersChanged = _minPrice != _previousMinPrice ||
        _maxPrice != _previousMaxPrice ||
        _minAverageRating != _previousMinAverageRating ||
        _maxAverageRating != _previousMaxAverageRating ||
        _selectedSortOption != _previousSortOption;

    if (filtersChanged) {
      setState(() {
        _posts.clear();
        _lastDocument = null;
        _isLoadingInitialData = true;
        _isLoadingMoreData = false;
      });

      _fetchInitialPosts();

      _previousMinPrice = _minPrice;
      _previousMaxPrice = _maxPrice;
      _previousMinAverageRating = _minAverageRating;
      _previousMaxAverageRating = _maxAverageRating;
      _previousSortOption = _selectedSortOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: SizedBox(),
        actions: [
          if ((_currentUser?.userType == model.UserType.business &&
                  _currentUser?.verificationStatus ==
                      model.VerificationStatus.approved) ||
              _currentUser?.userType == model.UserType.admin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  _requestStoragePermission();
                  // Navigate to AddPostScreen
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PickImage(),
                  ));
                },
                icon: Icon(
                  FluentIcons.add_square_28_filled,
                  size: 35,
                  color: maincolor,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  FeatherIcons.settings, // Use the desired Feather icon
                  color: maincolor, // Set the icon color
                  size: 24.0, // Set the icon size
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(15.0), // Set border radius
                          color: Colors.white, // Set background color
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Limit dropdown height
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
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: PopupMenuButton<SortOption>(
              color: backgroundColor,
              icon: Row(
                children: const [
                  Icon(Icons.filter_list),
                  SizedBox(width: 4),
                  Text('Filter'),
                ],
              ),
              initialValue: _selectedSortOption,
              onSelected: (value) {
                setState(() {
                  _selectedSortOption = value;
                });
                _applyFilter();
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SortOption>>[
                PopupMenuItem<SortOption>(
                  value: SortOption.lowToHigh,
                  child: const Text(
                    'Sort by Price: Low to High',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.highToLow,
                  child: const Text(
                    'Sort by Price: High to Low',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.lowToHighRate,
                  child: const Text(
                    'Sort by Rate: Low to High',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.highToLowRate,
                  child: const Text(
                    'Sort by Rate: High to Low',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.datePublishedAsc,
                  child: const Text(
                    'Sort by Date: Oldest First',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.datePublishedDesc,
                  child: const Text(
                    'Sort by Date: Newest First',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ],
        title: Image.asset(
          "assets/ooffeerrss.png",
          height: 150,
        ),
      ),
      body: Column(
        children: [
          if (_currentUser?.userType == model.UserType.business &&
              _currentUser?.verificationStatus ==
                  model.VerificationStatus.pending)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'حسابك قيد التدقيق قد يستغرق هذا بعض الوقت',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (_currentUser?.userType == model.UserType.business &&
              _currentUser?.verificationStatus ==
                  model.VerificationStatus.rejected)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "طلبك مرفوض",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(
            child: _isLoadingInitialData
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    color: maincolor,
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _posts.length + (_isLoadingMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < _posts.length) {
                          return _currentUser != null
                              ? PostCard(
                                  snap: _posts[index],
                                  currentUserUid: _currentUser!.uid,
                                )
                              : SizedBox.shrink();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, you can now access the storage
      // ...
    } else if (status.isDenied) {
      // Permission denied
      // Show a message indicating that the permission is required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Storage permission is required to perform this action.'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
    }
  }
}

enum SortOption {
  lowToHigh,
  highToLow,
  lowToHighRate,
  highToLowRate,
  datePublishedAsc,
  datePublishedDesc,
}
