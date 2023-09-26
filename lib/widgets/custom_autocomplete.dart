import 'package:flutter/material.dart';

class CustomAutoComplete extends StatefulWidget {
  final List options;
  final String property;
  final Map<String, dynamic>? frmValues;
  const CustomAutoComplete(
      {super.key,
      required this.options,
      required this.property,
      required this.frmValues});

  @override
  State<CustomAutoComplete> createState() => _CustomAutoCompleteState();
}

class _CustomAutoCompleteState extends State<CustomAutoComplete> {
  List<String> valuesToShow = [];
  List<String> valuesToSave = [];

  void extractValues() {
    for (var map in widget.options) {
      valuesToShow.add(map["key"]); //Honda, Nissan, Hyundai
      valuesToSave.add(map["value"]); //H, NS, HY
    }
  }

  @override
  void initState() {
    extractValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(optionsBuilder: (textEditingValue) {
      if (textEditingValue.text == "") {
        return [];
      }
      return valuesToShow.where((String element) {
        return element.contains(textEditingValue.text);
      });
    }, onSelected: (String item) {
      widget.frmValues![widget.property] =
          valuesToSave[valuesToShow.indexOf(item)];
      print(widget.frmValues);
    });
  }
}
