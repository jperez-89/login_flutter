import 'package:flutter/material.dart';

///Crea un widget de tipo CheckboxListTile
///Variables
///@label -> la etiqueta del checkbox
///@initialValue -> valor inicial del checkbox
///@property -> es el identificador de este campo dentro del frmValues
///@frmValues -> almacena todos los valores guardados en el formulario actual
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
    // ignore: unnecessary_null_comparison
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
