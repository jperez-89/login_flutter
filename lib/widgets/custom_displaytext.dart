import 'package:flutter/material.dart';

class CustomDisplayText extends StatelessWidget {
  final String title;
  final String value;
  const CustomDisplayText(
      {super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
          )
        ],
      ),
    );
  }
}
