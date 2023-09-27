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
      required this.property});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  // static DateTime fecha = DateTime.now();
  String fecha = '';

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
          fecha = getFecha(value);
          widget.frmValues[widget.property] = fecha;
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
    /** REVISAR COMO PEGA GUARDA LAS FECHAS EN LA BASE DE DATOS */
    widget.frmValues[widget.property] =
        "${fecha.day}/${fecha.month}/${fecha.year}";

    return widget.frmValues[widget.property];
    // return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.toolTip,
      child: TextFormField(
        autofocus: false,
        keyboardType: TextInputType.none,
        // controller: TextEditingController(text: getFecha()),
        controller: TextEditingController(text: fecha),
        onTap: _showDatePicker,
        decoration: InputDecoration(labelText: widget.label),
        enabled: widget.enabled,
        textAlign: widget.textAlign,
      ),
    );
  }
}
