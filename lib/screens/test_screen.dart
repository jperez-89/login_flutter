import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/widgets.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Map<String, String> globalGroupValue = {};
  List<Map<String, String>> opcionesAutoComplete = [
    {"H": "Honda"},
    {"HY": "Hyundai"},
    {"NS": "Nissan"},
    {"SZ": "Suzuki"},
    {"TY": "Toyota"}
  ];

  /*Wrap generarRadioButtons(String groupName) {
    final size = MediaQuery.of(context).size;
    List radioButtons = [];
    int maxElementInRow = 5;
    String orientation = "horizontal";
    if (!globalGroupValue.containsKey(groupName)) {
      globalGroupValue.addAll({groupName: ""});
    }
    for (int i = 0; i < 4; i++) {
      radioButtons.add(CustomRadioButton(
        value: "${i + 1}",
        groupValue: globalGroupValue[groupName]!,
        onchange: (value) {
          globalGroupValue[groupName] = value!;
          setState(() {});
        },
        size: size,
        maxElementInRow: maxElementInRow,
        orientation: orientation,
      ));
    }

    return Wrap(
      children: [...radioButtons],
    );
  }*/

  /*Autocomplete generarAutoCompete() {
    List<String> values = [];
    List<String> keys = [];

    for (var mapa in opcionesAutoComplete) {
      values.add(mapa.values.toString().replaceAll(RegExp(r'[()]'), ''));
      keys.add(mapa.keys.toString().replaceAll(RegExp(r'[()]'), ''));
    }
    return Autocomplete<String>(optionsBuilder: (textEditingValue) {
      if (textEditingValue.text == "") {
        return [];
      }
      return values.where((String element) {
        return element.contains(textEditingValue.text);
      });
    }, onSelected: (String item) {
      print(keys[values.indexOf(item)]);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Text("null"),
          FormBuilderWidget(
              pzInsKey:
                  "ASSIGN-WORKLIST%20CF-FW-INTERPRE-WORK%20R-11001!CARDATA")
          /*CustomAutoComplete(
            options: opcionesAutoComplete,
            frmValues: {},
            property: "primer autocomplete",
          )*/
        ]),
      ),
    );
  }
}
