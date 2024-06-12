import 'package:finalgradproj/utils/colors.dart';
import 'package:flutter/material.dart';

class CateSelectionDialog extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final List<String> cates;
  final Function(String) onCatesSelected;

  CateSelectionDialog({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.initialValue,
    required this.onCatesSelected,
    required this.cates,
  }) : super(key: key);

  @override
  _CateSelectionDialogState createState() => _CateSelectionDialogState();
}

class _CateSelectionDialogState extends State<CateSelectionDialog> {
  String? selectedCate;

  @override
  void initState() {
    super.initState();
    selectedCate = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, // Set the dialog background color to white
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(widget.hintText),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: widget.cates
                                .map((cate) => ListTile(
                                      title: Text(cate),
                                      selected: selectedCate == cate,
                                      selectedColor: selectedCate == cate ? whiteColor : null,
                                      onTap: () {
                                        setState(() {
                                          selectedCate = cate;
                                          widget.onCatesSelected(selectedCate!);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 208, 208, 208).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedCate ?? widget.hintText),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}