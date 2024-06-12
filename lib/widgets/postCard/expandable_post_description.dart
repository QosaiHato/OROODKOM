import 'package:finalgradproj/utils/colors.dart';
import 'package:finalgradproj/widgets/postCard/CustomTextView.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class ExpandablePostDescription extends StatefulWidget {
  final dynamic snap;

  ExpandablePostDescription({required this.snap});

  @override
  _ExpandablePostDescriptionState createState() =>
      _ExpandablePostDescriptionState();
}

class _ExpandablePostDescriptionState extends State<ExpandablePostDescription> {
  late final ExpandableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpandableController(initialExpanded: false);
    _controller.addListener(_toggleDescription);
  }

  @override
  void dispose() {
    _controller.removeListener(_toggleDescription);
    _controller.dispose();
    super.dispose();
  }

  void _toggleDescription() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: _controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextView(Name: "الفئة: ", text: widget.snap.category),
          Expandable(
            controller: _controller,
            collapsed: buildCollapsed(),
            expanded: buildExpanded(),
          ),
        ],
      ),
    );
  }

  Widget buildCollapsed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              _controller.toggle();
            },
            child: Text(
              'عرض الوصف',
              style: TextStyle(color: maincolor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildExpanded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: lightgrayColor.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        text: 'الوصف: ${widget.snap.description}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              _controller.toggle();
            },
            child: Text(
              'إخفاء الوصف',
              style: TextStyle(color: maincolor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
