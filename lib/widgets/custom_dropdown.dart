import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<DropdownMenuItem> menuItem;
  final String label;
  final String property;
  final Map<String, dynamic> frmValues;

  const CustomDropdown(
      {Key? key,
      required this.menuItem,
      required this.label,
      required this.property,
      required this.frmValues})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: label),
      items: menuItem,
      onChanged: (value) {
        frmValues[property] = value;
      },
    );
  }
}
