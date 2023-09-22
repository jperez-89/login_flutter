import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final String value;
  final String groupValue;
  final void Function(String?) onchange;
  final Size size;
  final int maxElementInRow;
  final String orientation;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onchange,
    required this.size,
    required this.maxElementInRow,
    required this.orientation,
  });

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: (widget.orientation == "horizontal")
            ? (widget.maxElementInRow < 4)
                ? BoxConstraints(
                    maxWidth: (widget.size.width / widget.maxElementInRow))
                : BoxConstraints(maxWidth: (widget.size.width / 4))
            : const BoxConstraints(),
        child: RadioListTile(
          value: widget.value,
          title: Text(widget.value),
          groupValue: widget.groupValue,
          onChanged: widget.onchange,
        ));
  }
}
