import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test_application/my_flutter_app_icons.dart';

class ClickableIconWidget extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  ClickableIconWidget(
      {Key? key, required this.label, required this.icon, required this.onTap})
      : super(key: key);

  @override
  _ClickableIconWidgetState createState() => _ClickableIconWidgetState();
}

class _ClickableIconWidgetState extends State<ClickableIconWidget> {
  bool isSelected = false; // State to track if the icon is selected

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected; // Toggle the selected state
          widget.onTap(); // Call the provided onTap function
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(
              widget.icon,
              size: 40.0,
              color: isSelected
                  ? Colors.red
                  : Colors.blue, // Change color based on the state
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.label,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
