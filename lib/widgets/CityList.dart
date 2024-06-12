import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';

class CitySelectionDialog extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final List<String> cities;
  final Function(String) onCitySelected;

  CitySelectionDialog({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.initialValue,
    required this.onCitySelected,
    required this.cities,
  }) : super(key: key);

  @override
  _CitySelectionDialogState createState() => _CitySelectionDialogState();
}

class _CitySelectionDialogState extends State<CitySelectionDialog> {
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    selectedCity = widget.initialValue;
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
                  SelectDialog.showModal<String>(
                    context,
                    label: widget.hintText,
                    items: widget.cities,
                    selectedValue: selectedCity,
                    onChange: (String selected) {
                      setState(() {
                        selectedCity = selected;
                        widget.onCitySelected(selectedCity!);
                      });
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
                      Text(selectedCity ?? widget.hintText),
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
