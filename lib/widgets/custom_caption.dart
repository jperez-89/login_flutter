import 'package:flutter/material.dart';

/// Crea un widget Text con padding vertical (top=20, buttom=20) que se utiliza como encabezado de seccion
/// @value -> el texto a mostrar
/// @fontSize -> el tamaño de la fuente
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
