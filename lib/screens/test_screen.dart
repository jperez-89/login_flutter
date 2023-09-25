import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/widgets.dart';

/** screen for dev test propose */
class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String groupValue = "";
  List<String> opcionesAutoComplete = [
    "bryan",
    "es",
    "muy",
    "genial",
    "uyuyu bajura"
  ];
  Wrap generarRadioButtons() {
    final size = MediaQuery.of(context).size;
    List radioButtons = [];
    int maxElementInRow = 5;
    String orientation = "horizontal";
    for (int i = 0; i < 10; i++) {
      radioButtons.add(CustomRadioButton(
        value: "${i + 1}",
        groupValue: groupValue,
        onchange: (value) {
          groupValue = value!;
          setState(() {});
        },
        size: size,
        maxElementInRow: (orientation == "horizontal" && maxElementInRow < 4)
            ? maxElementInRow
            : 4,
        orientation: orientation,
      ));
    }
    return Wrap(
      children: [...radioButtons],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
              //generarRadioButtons()
              Autocomplete<String>(
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text == "") {
            //return const Iterable<String>.empty();
            return [];
          }
          return opcionesAutoComplete.where((String item) {
            return item.contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String item) {
          print("Se seleccionó $item");
        },
      )),
    );
  }
}
