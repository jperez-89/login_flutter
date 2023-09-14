import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<DropdownMenuItem> menuItem;
  final String label;
  const CustomDropdown({Key? key, required this.menuItem, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: label),
      items: menuItem,
      onChanged: (value) {},
    );
  }
}
