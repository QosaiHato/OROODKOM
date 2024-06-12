import 'dart:typed_data';
import 'package:finalgradproj/resources/firestore_methods.dart';
import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/CAtegoryList.dart';
import 'package:finalgradproj/widgets/CityList.dart';
import 'package:finalgradproj/widgets/CustomTextField.dart';
import 'package:finalgradproj/widgets/phoneNumberfield.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  final List<Uint8List> images;
  final String currentUserId;
  final String currentUsername;
  final String profileImageUrl;

  SecondPage({
    Key? key,
    required this.images,
    required this.currentUserId,
    required this.currentUsername,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _whatsappNumberController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedCity = '';
  String _selectedCategory = '';
  bool isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _productNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _whatsappNumberController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('املا المعلومات'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(
                labelText: "اسم المنتج",
                hintText: "اسم المنتج",
                textEditingController: _productNameController,
                texttype: TextInputType.name,
                nextnode: TextInputAction.next,
              ),
              CustomTextField(
                labelText: "السعر",
                hintText: "السعر",
                textEditingController: _priceController,
                texttype: TextInputType.numberWithOptions(),
                nextnode: TextInputAction.next,
              ),
              CateSelectionDialog(
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
                labelText: '',
                hintText: "اختر الفئة",
                onCatesSelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
              CitySelectionDialog(
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
                labelText: '',
                hintText: "اختر المدينة",
                onCitySelected: (city) {
                  setState(() {
                    _selectedCity = city;
                  });
                },
              ),
              JordanPhoneNumberInput(
                controller: _phoneNumberController,
                text: ' رقم الهاتف',
              ),
              CustomTextField(
                labelText: "العنوان",
                hintText: "العنوان",
                textEditingController: _addressController,
                texttype: TextInputType.streetAddress,
                nextnode: TextInputAction.done,
              ),
              CustomTextField(
                labelText: "الوصف",
                hintText: "الوصف",
                textEditingController: _descriptionController,
                texttype: TextInputType.text,
                nextnode: TextInputAction.next,
                isMultiline: true,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(maincolor),
                ),
                onPressed: () {
                  postImages();
                },
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        ),
                      )
                    : Text(
                        'Submit',
                        style: TextStyle(color: whiteColor),
                      ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  void postImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        widget.images,
        widget.currentUserId,
        widget.currentUsername,
        widget.profileImageUrl,
        _productNameController.text,
        _addressController.text,
        _phoneNumberController.text,
        _whatsappNumberController.text,
        _selectedCity,
        _selectedCategory,
        double.tryParse(_priceController.text) ?? 0.0,
      );

      if (res == "success") {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Posted')),
          );
        }
        clearImages();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to post')),
          );
        }
      }
    } catch (err) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        );
      }
    }
  }

  void clearImages() {
    setState(() {
      widget.images.clear();
    });
  }
}
