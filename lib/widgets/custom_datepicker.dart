import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final String? toolTip;
  final TextAlign textAlign;
  final bool? enabled;
  final bool useFutureDateRange;
  final bool usePastDateRange;
  final int futureDateRange;
  final int pastDateRange;

  const CustomDatePicker(
      {super.key,
      this.toolTip,
      required this.label,
      this.textAlign = TextAlign.center,
      this.enabled = true,
      this.futureDateRange = 10,
      this.pastDateRange = 10,
      this.useFutureDateRange = false,
      this.usePastDateRange = false});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  static DateTime fecha = DateTime.now();

  void _showDatePicker() {
    FocusScope.of(context).unfocus();
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                getFristDate(widget.usePastDateRange, widget.pastDateRange)),
            lastDate: DateTime(
                getLastDate(widget.useFutureDateRange, widget.futureDateRange)))
        .then((value) {
      setState(() {
        fecha = value!;
      });
    });
  }

  int getFristDate(bool usePastDays, int pastDateRange) {
    return (usePastDays) ? fecha.year - pastDateRange : 10;
  }

  int getLastDate(bool useFutureDays, int futureDateRange) {
    return (useFutureDays) ? fecha.year + futureDateRange : 10;
  }

  String getFecha() {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.toolTip,
      child: TextFormField(
        autofocus: false,
        keyboardType: TextInputType.none,
        controller: TextEditingController(text: getFecha()),
        onTap: _showDatePicker,
        decoration: InputDecoration(labelText: widget.label),
        enabled: widget.enabled,
        textAlign: widget.textAlign,
      ),
    );
  }
}
