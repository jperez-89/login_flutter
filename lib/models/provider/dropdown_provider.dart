import 'package:flutter/material.dart';

class DropdownProvider with ChangeNotifier {
  Map<String, dynamic> _dropDownDataList = {};

  get dropDwonDataList => _dropDownDataList;

  addDropDownData(String key, List values) {
    _dropDownDataList[key] = values;
    notifyListeners();
  }

  List getElement(String nameOfElement) {
    List prueba = [];
    if (_dropDownDataList.containsKey(nameOfElement)) {
      prueba = _dropDownDataList[nameOfElement];
      print("obteniendo lista de $nameOfElement => $prueba");
    }
    return prueba;
    /*return (_dropDownDataList.containsKey(nameOfElement))
        ? _dropDownDataList[nameOfElement]
        : [];*/
  }
}
