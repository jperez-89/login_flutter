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
  final Map<String, dynamic> frmValues;
  final String property;
  final String? initialValue;

  const CustomDatePicker(
      {super.key,
      this.toolTip,
      required this.label,
      this.textAlign = TextAlign.center,
      this.enabled = true,
      this.futureDateRange = 10,
      this.pastDateRange = 10,
      this.useFutureDateRange = false,
      this.usePastDateRange = false,
      required this.frmValues,
      required this.property,
      this.initialValue});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  String date = "";
  bool dateIsChanged = false;

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
        if (value != null) {
          date = getFecha(value);
          dateIsChanged = true;
          widget.frmValues[widget.property] = date;
        }
      });
    });
  }

  int getFristDate(bool usePastDays, int pastDateRange) {
    return (usePastDays) ? DateTime.now().year - pastDateRange : 10;
  }

  int getLastDate(bool useFutureDays, int futureDateRange) {
    return (useFutureDays) ? DateTime.now().year + futureDateRange : 10;
  }

  String getFecha(DateTime fecha) {
    String month =
        fecha.month < 10 ? "0${fecha.month}" : fecha.month.toString();

    String day = fecha.day < 10 ? "0${fecha.day}" : fecha.day.toString();

    widget.frmValues[widget.property] = "${fecha.year}-$month-$day";

    return widget.frmValues[widget.property];
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.toolTip,
      child: TextFormField(
        autofocus: false,
        keyboardType: TextInputType.none,
        controller: TextEditingController(
            text: (widget.initialValue != null && !dateIsChanged)
                ? widget.initialValue
                : date),
        onTap: _showDatePicker,
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        enabled: widget.enabled,
        textAlign: widget.textAlign,
      ),
    );
  }
}
