import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
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

  Widget currencyInput() {
    /*return TextField(
      inputFormatters: [CurrencyTextInputFormatter(decimalDigits: 5)],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      onSubmitted: (value) {
        print(value);
      },
    );*/
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          CustomDropdown(
              menuItem: const [
                DropdownMenuItem(child: Text("Pedro")),
                DropdownMenuItem(child: Text("Maria"))
              ],
              label: "hola",
              property: "hola",
              frmValues: opcionesAutoComplete[0])
          /*FormBuilderWidget(
              pzInsKey:
                  "ASSIGN-WORKLIST%20CF-FW-INTERPRE-WORK%20R-11001!CARDATA")*/
        ]),
      ),
    );
  }
}
