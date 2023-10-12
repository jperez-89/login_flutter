import 'package:flutter/material.dart';

class DropdownProvider with ChangeNotifier {
  List dropDownDataList = [];

  addDropDownData(Map<String, dynamic> dropdownData) {
    dropDownDataList.add(dropdownData);
    notifyListeners();
  }
}
