import 'package:flutter/material.dart';

class InputsWidget extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final int? minLength;
  final int? maxLength;
  final TextInputType? inputType;
  final bool? obscureText;
  final String property;
  final Map<String, dynamic>? frmValues;
  final TextAlign? textAlign;
  final bool? readOnly;
  final String? toolTip;

  const InputsWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.icon,
    this.minLength,
    this.inputType,
    this.obscureText,
    required this.property,
    this.frmValues,
    this.maxLength,
    this.textAlign,
    this.readOnly,
    this.toolTip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: toolTip,
      child: TextFormField(
        keyboardType: inputType,
        textCapitalization: TextCapitalization.words,
        obscureText: obscureText ?? false,
        onChanged: (value) =>
            frmValues![property] = value, // Almacena lo ingresado en el form
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
      ),
    );
  }
}
