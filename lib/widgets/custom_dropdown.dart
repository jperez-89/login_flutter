import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_flutter/models/services/datapages_services.dart';

class CustomDropdown extends StatelessWidget {
  final List<DropdownMenuItem> menuItem;
  final String label;
  final String property;
  final Map<String, dynamic> frmValues;
  final String? initialValue;
  final String placeholder;
  final Map<String, dynamic> dropdownParamsList;
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
      required this.dropdownParamsList,
      required this.reference,
      required this.callback});

  void fillData(String dataSelected) {
    print(dropdownParamsList);
    if (dropdownParamsList.containsKey(reference)) {
      String myDataPromptName = reference;
      Map<String, dynamic> dependentChild =
          dropdownParamsList[myDataPromptName];
      String urlToGet = dependentChild["Endpoint"] + dataSelected;
      List options = [];
      Datapages().getDataPage(urlToGet).then((value) {
        Map<String, dynamic> json = jsonDecode(value.body);
        for (var result in json["pxResults"]) {
          options.add({
            "key": result[dependentChild["dataPageValue"]],
            "value": result[dependentChild["dataPagePromptName"]]
          });
        }
        print(options);
        dropdownParamsList["$reference/list"] = options;
        callback();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(placeholder),
      value: initialValue,
      decoration: InputDecoration(labelText: label),
      items: menuItem,
      onChanged: (value) {
        frmValues[property] = value;
        fillData(value);
      },
    );
  }
}
