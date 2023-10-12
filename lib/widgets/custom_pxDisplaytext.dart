import 'package:flutter/material.dart';

/// crea un widget parar mostrar 2 lineas de texto una sobre otra, la primera la dibuja en negrita
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
          )
        ],
      ),
    );
  }
}
