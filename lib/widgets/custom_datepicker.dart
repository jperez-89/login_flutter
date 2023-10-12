import 'package:flutter/material.dart';

///crea un textfromfield que en su evento onTap muestra un modal con datepicker
///Variables
/// @label -> la etiqueta del campo
/// @tolTip -> texto de ayuda al usuario
/// @TextAlign -> alineacion del texto dentro del textformfield
/// @enabled -> indica si el campo esta o no habilidado
/// @useFutureDateRange -> validacion de PEGA para evitar que se seleccionen fechas futuras
/// @usePastDateRange -> validacion de PEGA para evitar que se seleccionen fecha pasadas
/// @futureDateRange -> cantidad de años futuros a partir de la fecha actual a mostrar en el calendario
/// @pastDateRangeg -> cantidad de año pasado a partirr de la fehca actual a mostrar en el calendario
/// @property -> es el identificador de este campo dentro del frmValues
/// @frmValues -> almacena todos los valores guardados en el formulario actual
/// @initialValue -> valor inicial al renderizar el widget
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
  // static DateTime fecha = DateTime.now();
  String date = "";
  bool dateIsChanged = false;

  /// abre el modal con el calendario
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

  /// setea la cantidad de año pasados a mostrar por defecto 10
  int getFristDate(bool usePastDays, int pastDateRange) {
    return (usePastDays) ? DateTime.now().year - pastDateRange : 10;
  }

  /// setea la cantidad de año futuros a mostrar por defecto 10
  int getLastDate(bool useFutureDays, int futureDateRange) {
    return (useFutureDays) ? DateTime.now().year + futureDateRange : 10;
  }

  /// setea la fecha seleccionada por el usuario
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
        // controller: TextEditingController(text: getFecha()),
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
