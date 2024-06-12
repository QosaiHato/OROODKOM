import 'package:finalgradproj/firebase_options.dart';
import 'package:finalgradproj/providers/BottomNavigationProvider.dart';
import 'package:finalgradproj/providers/RatingProvider.dart';
import 'package:finalgradproj/providers/ScrollControllerProvider%20.dart';
import 'package:finalgradproj/providers/user_provider.dart';
import 'package:finalgradproj/responsive/mobile_screen_layout.dart';
import 'package:finalgradproj/responsive/responsive_layout_screen.dart';
import 'package:finalgradproj/responsive/web_screen_layout.dart';
import 'package:finalgradproj/screens/feed_screen.dart';
import 'package:finalgradproj/screens/login_screen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // Set debug to true to enable debug logging
      );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => LikesDislikesCountProvider()),
        ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
        ChangeNotifierProvider(
          create: (_) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (context) => RatingProvider(),
          child: MyApp(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          routes: {"feedscreen": (context) => FeedScreen()},
          debugShowCheckedModeBanner: false,
          title: 'Clone',
          theme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            // Set the primary color to your desired color
            primaryColor: blueColor, // Or any other color you prefer
            hintColor: textColor,
            // Set the indicatorColor to the same or a contrasting color
            indicatorColor: blueColor, // Or adjust based on primaryColor
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: maincolor,
                selectionColor: maincolor,
                selectionHandleColor: lightgrayColor),
            // Control progress indicator color
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: maincolor, // Set to your desired color
            ),

            // Control bottom navigation bar icon color
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.amber, // Set to your desired color
              unselectedItemColor:
                  Colors.grey.shade400, // Set to a lighter color
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                } else {
                  return LoginScreen(); // Show login screen if user data is null
                }
              } else if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber, // Or adjust based on primaryColor
                  ),
                );
              } else {
                return LoginScreen(); // Handle all other states by showing login screen
              }
            },
          ),
        ),
      ),
    );
  }
}
