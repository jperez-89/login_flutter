import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final String value;
  // final String groupValue;
  // final void Function(String?) onchange;
  final Size size;
  final int maxElementInRow;
  final String orientation;
  final String property;
  final Map<String, dynamic> frmValues;

  const CustomRadioButton({
    super.key,
    required this.value,
    //required this.groupValue,
    //s required this.onchange,
    required this.size,
    required this.maxElementInRow,
    required this.orientation,
    required this.property,
    required this.frmValues,
  });

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: widget.value,
      title: Text(widget.value),
      groupValue: widget.frmValues[widget.property],
      onChanged: (value) {
        widget.frmValues[widget.property] = value!;
        setState(() {
          print(widget.frmValues);
        });
      },
    );
  }
}
