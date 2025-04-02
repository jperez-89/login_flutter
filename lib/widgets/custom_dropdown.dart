import 'package:flutter/material.dart';
import 'package:login_flutter/models/provider/dropdown_provider.dart';
import 'dart:convert';
// PGFL-32_Implementar_dropdown_anidados
import 'package:login_flutter/models/services/datapages_services.dart';
import 'package:provider/provider.dart';
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
  final List menuItem;
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
  List x = [];
  List<DropdownMenuItem> createMenuItem(List itemList) {
    List<DropdownMenuItem> menuItems = [];
    for (var item in itemList) {
      menuItems.add(
          DropdownMenuItem(value: item["key"], child: Text(item["value"])));
    }
    return menuItems;
  }

  void setParameter(String dataSelected) {
    context.read<DropdownProvider>().addParam(widget.reference, dataSelected);
  }

  void fillData(String dataSelected) {
    List keys = widget.dropdownList.keys.toList();
/ PGFL-32_Implementar_dropdown_anidados
    Map dropdownList = widget.dropdownList;
    for (var key in keys) {
      bool allParametersSet = true;
      if (dropdownList[key].containsKey("parameters")) {
        for (var i = 0; i < dropdownList[key]["parameters"].length; i++) {
          if (dropdownList[key]["parameters"][i]
              .containsValue(widget.reference)) {
            dropdownList[key]["parameters"][i]["data"] = dataSelected;

//    for (var i = 0; i < keys.length; i++) {
  //    if (widget.dropdownList[keys[i]].runtimeType.toString().contains("Map") &&
    //      widget.dropdownList[keys[i]].containsKey("parameters")) {
     //   List parameters = widget.dropdownList[keys[i]]["parameters"];
      //  bool isDataFill = true;
       // bool isUpdated = false;

  //      for (var j = 0; j < parameters.length; j++) {
  //        if (parameters[j].containsValue(widget.reference)) {
  //          parameters[j]["data"] = dataSelected;
  //          isUpdated = true;

          }
          allParametersSet = (allParametersSet)
              ? (dropdownList[key]["parameters"][i]["data"] != "")
              : allParametersSet;
        }
// PGFL-32_Implementar_dropdown_anidados
        if (allParametersSet && key != widget.reference) {
          context.read<DropdownProvider>().addDropDownData(key, []);
          fetchData(dropdownList[key], key);
          cleanParameter(dropdownList[key]["parameters"]);

    //    if (isDataFill && keys[i] != widget.reference && isUpdated) {
    //      fetchData(widget.dropdownList[keys[i]], keys[i]);
    //    }
      }
    }
  }

  void cleanParameter(List parameters) {
    for (var i = 0; i < parameters.length; i++) {
      if (parameters[i].containsValue(widget.reference)) {
        parameters[i]["data"] = "";
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
// PGFL-32_Implementar_dropdown_anidados
          // widget.dropdownList["$name/list"] = options;
          context.read<DropdownProvider>().addDropDownData(name, options);
          // widget.callback();

//          print("$name seteada");
 //         widget.dropdownList["$name/list"] = options;
          //callback(options, name);
 //         widget.callback();

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
      /* items: createMenuItem((widget.menuItem != [])
          ? widget.menuItem
          : ),*/
      items: (widget.menuItem == [])
          ? createMenuItem(
              context.watch<DropdownProvider>().getElement(widget.reference))
          : createMenuItem(widget.menuItem),
      onChanged: (selected) {
        widget.frmValues[widget.property] = selected;
        setParameter(selected);
        fillData(selected!);
      },
    );
  }
}
