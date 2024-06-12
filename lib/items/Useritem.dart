// import 'package:finalgradproj/models/user.dart';
// import 'package:finalgradproj/screens/profile_screen.dart';
// import 'package:flutter/material.dart';


// class UserItem extends StatelessWidget {
//   final User user;

//   const UserItem({
//     Key? key,
//     required this.user,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => Scaffold(
//               body: ProfileScreen(uid: user.uid),
//             ),
//           ),
//         );
//       },
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage(user.photoUrl),
//         ),
//         title: Text(user.username),
//       ),
//     );
//   }
// }
