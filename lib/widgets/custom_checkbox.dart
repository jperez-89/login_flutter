import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final String label;
  final bool initialValue;
  final Map<String, dynamic> frmValues;
  final String property;
  const CustomCheckBox(
      {super.key,
      required this.label,
      required this.initialValue,
      required this.frmValues,
      required this.property});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool pressed = false;
  bool valueChaned = false;
  void evaluateValue() {
    pressed = valueChaned ? (widget.initialValue != null) : pressed;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.label),
      value: pressed,
      onChanged: (value) {
        setState(() {
          pressed = !pressed;
        });
      },
    );
  }
}
