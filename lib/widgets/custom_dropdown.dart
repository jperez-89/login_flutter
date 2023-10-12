import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_flutter/models/actions/datapage_actions.dart';

/// crea un widget del tipo DropdownButtonFormField
/// Variables
/// @menuItem -> es la lista de opcione a mostrar
/// @label -> la etiqueta del campo
/// @property -> es el identificador de este campo dentro del frmValues
/// @frmValues -> almacena todos los valores guardados en el formulario actual
/// @initialValue -> valor inicial al renderizar el widget
/// @placeholder -> texto a mostrar cuando no haya valor seleccionado
/// @dropdownList -> lista de paramtros requeridos por los todo los dropdown del formulario
/// @reference -> nombre del la property en PEGA donde se almacena el valor de este campo.
/// @callback -> metodo que se utiliza para redibujar el frmbuilder
class CustomDropdown extends StatefulWidget {
  final List<DropdownMenuItem> menuItem;
  final String label;
  final String property;
  final Map<String, dynamic> frmValues;
  final String? initialValue;
  final String placeholder;
  final Map<String, dynamic> dropdownList;
  final String reference;
  final Function callback;

  const CustomDropdown(
      {super.key,
      required this.menuItem,
      required this.label,
      required this.property,
      required this.frmValues,
      required this.initialValue,
      this.placeholder = '',
      required this.dropdownList,
      required this.reference,
      required this.callback});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  void fillData(String dataSelected) {
    List keys = widget.dropdownList.keys.toList();

    for (var i = 0; i < keys.length; i++) {
      if (widget.dropdownList[keys[i]].runtimeType.toString().contains("Map") &&
          widget.dropdownList[keys[i]].containsKey("parameters")) {
        List parameters = widget.dropdownList[keys[i]]["parameters"];
        bool isDataFill = true;
        bool isUpdated = false;

        for (var j = 0; j < parameters.length; j++) {
          if (parameters[j].containsValue(widget.reference)) {
            parameters[j]["data"] = dataSelected;
            isUpdated = true;
          }

          isDataFill = (isUpdated && isDataFill)
              ? (parameters[j]["data"] != "")
              : isDataFill;
          if (!isDataFill) return;
        }

        if (isDataFill && keys[i] != widget.reference && isUpdated) {
          fetchData(widget.dropdownList[keys[i]], keys[i]);
        }
      }
    }
  }

  void fetchData(Map dropdown, String name) async {
    List options = [];

    await DataPageActions().getDataPage(makeEndpoint(dropdown)).then((value) {
      if (value.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(value.body);

        if (json["pxResults"].length > 0) {
          for (var result in json["pxResults"]) {
            options.add({
              "key": result[dropdown["dataPageValue"]],
              "value": result[dropdown["dataPagePromptName"]]
            });
          }

          print("$name seteada");
          widget.dropdownList["$name/list"] = options;
          //callback(options, name);
          widget.callback();
        }
      }
    });
  }

  String makeEndpoint(Map dropdown) {
    String endpoint = "${dropdown['dataPageName']}?";

    for (var i = 0; i < dropdown["parameters"].length; i++) {
      endpoint += (i == 0)
          ? "${dropdown['parameters'][i]['name']}=${dropdown['parameters'][i]['data']}"
          : "&${dropdown['parameters'][i]['name']}=${dropdown['parameters'][i]['data']}";
    }

    return endpoint;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(widget.placeholder),
      value: (widget.initialValue == null) ? null : widget.initialValue,
      decoration: InputDecoration(labelText: widget.label),
      items: widget.menuItem,
      onChanged: (selected) {
        widget.frmValues[widget.property] = selected;
        fillData(selected);
        setState(() {});
      },
    );
  }
}
