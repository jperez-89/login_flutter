import 'package:flutter/material.dart';

class InputsWidget extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final int? minLength;
  final TextInputType? inputType;
  final bool obscureText;
  final String property;
  final Map<String, dynamic> frmValues;

  const InputsWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.icon,
    this.minLength,
    this.inputType,
    this.obscureText = false,
    required this.property,
    required this.frmValues,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      textCapitalization: TextCapitalization.words,
      obscureText: obscureText,
      onChanged: (value) =>
          frmValues[property] = value, // Almacena lo ingresado en el form
      validator: (value) {
        if (value == null) return 'Campo requerido';
        return value.length < minLength! ? 'Minimo $minLength letras' : null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
