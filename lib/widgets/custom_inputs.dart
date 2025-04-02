import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_flutter/theme/app_theme.dart';

class CustomInputs extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? icon;
  final int? maxLines;
  final int? minLength;
  final int? maxLength;
  final TextInputType? inputType;
  final bool? obscureText;
  final String property;
  final Map<String, dynamic>? frmValues;
  final TextAlign? textAlign;
  final bool? readOnly;
  final String? toolTip;
  final bool? disabled;
  final bool? isRequired;
  final String? initialValue;

  const CustomInputs({
    super.key,
    this.labelText,
    this.hintText,
    this.icon,
    this.minLength = 3,
    this.inputType,
    this.obscureText,
    required this.property,
    this.frmValues,
    this.maxLength,
    this.textAlign,
    this.readOnly,
    this.toolTip,
    this.disabled,
    this.isRequired = false,
    this.initialValue,
    this.inputFormatters = const [],
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      keyboardType: inputType,
      textCapitalization: TextCapitalization.words,
      obscureText: obscureText ?? false,
      onChanged: (value) =>
          frmValues![property] = value, // Almacena dato ingresado en el form
      validator: (value) {
        if (isRequired! && value == '') return 'Campo Obligatorio';
        // if (value == '') return 'Completa este campo';
        // if (value == null) return 'Campo requerido';
        // print(value);
        return value!.isNotEmpty ? null : value;
        // return value.length < minLength! ? 'Minimo $minLength letras' : null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: icon != null
          ? InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppTheme.primaryColor),
                borderRadius: BorderRadius.circular(20),
              ),
            )
          : InputDecoration(
              labelText: isRequired! ? '$labelText *' : labelText,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppTheme.primaryColor),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
      enabled: disabled,
      // initialValue: initialValue,
      controller: TextEditingController(text: initialValue),
    );
  }
}
