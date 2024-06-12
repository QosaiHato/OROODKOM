import 'package:finalgradproj/screens/RelatedPostsScreen.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final List<String> categories = [
    "الإلكترونيات",
    "الملابس",
    "المنزل والمطبخ",
    "الجمال والعناية الشخصية",
    "الكتب",
    "الألعاب ",
    "الرياضة والهوايات",
    "السيارات",
    "الأدوات وتحسين المنزل",
    "الطفل",
    "لوازم الحيوانات الأليفة",
    "منتجات المكتب",
    " الحرف اليدوية",
    "ألعاب الفيديو",
  ];
  final String? initialSelectedCategory;

  CategoryScreen({this.initialSelectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('الفئات'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            selectedColor: initialSelectedCategory == category ? primaryColor : null,
            selected: initialSelectedCategory == category,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RelatedPostsScreen(
                    query: category,
                    whereToSearch: 'category',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}