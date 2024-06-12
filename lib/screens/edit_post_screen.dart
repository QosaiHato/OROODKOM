import 'package:finalgradproj/models/post.dart';
import 'package:finalgradproj/resources/firestore_methods.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/CAtegoryList.dart';
import 'package:finalgradproj/widgets/CityList.dart';
import 'package:finalgradproj/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _profImageController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _whatsappNumberController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<String> _imageUrls = [];
  String? _selectedCategory;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.post.description;
    _categoryController.text = widget.post.category;
    _selectedCategory = widget.post.category;
    _usernameController.text = widget.post.username;
    _profImageController.text = widget.post.profImage;
    _productNameController.text = widget.post.productName;
    _addressController.text = widget.post.address;
    _phoneNumberController.text = widget.post.phoneNumber;
    _whatsappNumberController.text = widget.post.whatsappNumber;
    _cityController.text = widget.post.city;
    _selectedCity = widget.post.city;
    _priceController.text = widget.post.price.toString();
    _imageUrls = widget.post.postUrls ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                labelText: 'Product Name',
                hintText: 'Enter product name',
                textEditingController: _productNameController,
                checks: 'bio',
                nextnode: TextInputAction.next,
                texttype: TextInputType.text,
              ),
              CateSelectionDialog(
                labelText: 'Category',
                hintText: 'Select category',
                onCatesSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected;
                    _categoryController.text = selected;
                  });
                },
                cates: [
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
                ],
                initialValue: _categoryController.text,
              ),
              CustomTextField(
                labelText: 'Address',
                hintText: 'Enter address',
                textEditingController: _addressController,
                checks: 'bio',
                nextnode: TextInputAction.next,
                texttype: TextInputType.text,
              ),
              CustomTextField(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
                textEditingController: _phoneNumberController,
                checks: 'phone',
                nextnode: TextInputAction.next,
                texttype: TextInputType.phone,
              ),
              CustomTextField(
                labelText: 'Whatsapp Number',
                hintText: 'Enter whatsapp number',
                textEditingController: _whatsappNumberController,
                checks: 'phone',
                nextnode: TextInputAction.next,
                texttype: TextInputType.phone,
              ),
              CitySelectionDialog(
                  labelText: 'City',
                  hintText: 'Select city',
                  onCitySelected: (selected) {
                    setState(() {
                      _selectedCity = selected;
                      _cityController.text = selected;
                    });
                  },
                  cities: [
                    'عمّان (العاصمة)',
                    'إربد',
                    'الزرقاء',
                    'المفرق',
                    'عجلون',
                    'جرش',
                    'مادبا',
                    'البلقاء',
                    'الكرك',
                    'الطفيلة',
                    'معان',
                    'العقبة',
                  ],
                  initialValue: _cityController.text),
              CustomTextField(
                labelText: 'Price',
                hintText: 'Enter price',
                textEditingController: _priceController,
                checks: 'bio',
                nextnode: TextInputAction.done,
                texttype: TextInputType.number,
              ),
              CustomTextField(
                labelText: 'Description',
                hintText: 'Enter description',
                textEditingController: _descriptionController,
                checks: 'bio',
                nextnode: TextInputAction.next,
                isMultiline: true,
                texttype: TextInputType.text,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(whiteColor)),
                onPressed: () {
                  FirestoreMethods().updatePost(
                    widget.post.postId,
                    _descriptionController.text,
                    _categoryController.text,
                    _usernameController.text,
                    _profImageController.text,
                    _productNameController.text,
                    _addressController.text,
                    _phoneNumberController.text,
                    _whatsappNumberController.text,
                    _cityController.text,
                    double.parse(_priceController.text),
                    _imageUrls,
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save Changes',
                  style: TextStyle(color: maincolor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
