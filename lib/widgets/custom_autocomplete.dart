import 'package:flutter/material.dart';

class CustomAutoComplete extends StatefulWidget {
  final List options;
  final String property;
  final Map<String, dynamic> frmValues;
  final Map<String, dynamic> dataPagePrompt;
  final String dataPagePromptName;
  final Function callback;
  final String label;
  const CustomAutoComplete(
      {super.key,
      required this.options,
      required this.property,
      required this.frmValues,
      required this.dataPagePrompt,
      required this.dataPagePromptName,
      required this.callback,
      required this.label});

  @override
  State<CustomAutoComplete> createState() => _CustomAutoCompleteState();
}

class _CustomAutoCompleteState extends State<CustomAutoComplete> {
  List<String> valuesToShow = [];
  List<String> valuesToSave = [];

  void extractValues() {
    valuesToShow = [];
    valuesToSave = [];
    for (var map in widget.options) {
      valuesToShow.add(map["key"]); //Honda, Nissan, Hyundai
      valuesToSave.add(map["value"]); //H, NS, HY
    }
  }

  @override
  Widget build(BuildContext context) {
    extractValues();
    return Autocomplete<String>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onEditingComplete: onFieldSubmitted,
          decoration: InputDecoration(
            label: Text(widget.label),
          ),
        );
      },
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text == "") {
          return [];
        }
        return valuesToShow.where((String element) {
          return element
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String item) {
        widget.frmValues[widget.property] =
            valuesToSave[valuesToShow.indexOf(item)];

        widget.dataPagePrompt[widget.dataPagePromptName] =
            widget.frmValues[widget.property];
        widget.callback();
      },
    );
  }
}
