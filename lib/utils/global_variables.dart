import 'package:finalgradproj/screens/feed_screen.dart';
import 'package:finalgradproj/screens/ProfileScreen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

const webScreenSize = 600;

final homeScreenItems = [
  const FeedScreen(),
  // const SearchScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  // const AddPostScreen(),
  //const Center(child: Text('Favorites')),
];
