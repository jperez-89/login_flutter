import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/widgets.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  //QuillController _controller = QuillController.basic();

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
      maxLines: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        currencyInput(),
        const Text("HOL"),
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
              TextSpan(
                  text: "Titulo",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text: "Dato",
              )
            ]))
      ],
    ));
  }
}
