// import 'package:flutter/material.dart';
// import 'package:flutter_instagram/models/post.dart';
// import 'package:flutter_instagram/screens/post_card.dart';
// import 'package:flutter_instagram/utils/colors.dart';

// class PostItem extends StatelessWidget {
//   final Post post;
//   final String currentuser;
//   const PostItem({
//     Key? key,
//     required this.post,
//     required this.currentuser
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => Scaffold(
//               body: ListView(
//                 children: [
//                   PostCard(
//                     snap: post,
//                     currentUserUid: currentuser,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//         height: 100,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Image.network(
//                   post.postUrl,
//                   fit: BoxFit.fill,
//                   width: 100,
//                   height: 100,
//                 ),
//               ),
//               Spacer(flex: 1),
//               Flexible(
//                 child: Text.rich(
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: textColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                   TextSpan(children: [
//                     TextSpan(text: post.productName),
//                   ]),
//                 ),
//               ),
//               Spacer(flex: 2),
//               Container(
//                 height: 25,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   color: lightgrayColor.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Center(
//                   child: Text(
//                     overflow: TextOverflow.ellipsis,
//                     "${post.price}\$",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: textColor.withOpacity(0.8),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
