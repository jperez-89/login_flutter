import 'package:flutter/material.dart';

class CustomCaption extends StatelessWidget {
  final String value;
  final double fontSize;

  const CustomCaption({super.key, required this.value, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        value,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
