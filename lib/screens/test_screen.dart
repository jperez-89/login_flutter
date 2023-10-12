import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:login_flutter/widgets/form_builder.dart';

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

  Widget currencyInput(String titulo, String valor) {
    /*return TextField(
      inputFormatters: [CurrencyTextInputFormatter(decimalDigits: 5)],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      onSubmitted: (value) {
        print(value);
      },
    );*/
    /*return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 5,
    );*/
    return ConstrainedBox(
      constraints: const BoxConstraints(),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            valor,
          )
        ],
      ),
    );
  }

  List<Widget> x() {
    List<Widget> output = [];
    for (var i = 0; i < 100; i++) {
      /* output.add(ListTile(
        title: RichText(
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
          const TextSpan(text: "\nNOMBRE: "),
          const TextSpan(
              text:
                  "Est et quis mollit duis aliqua consequat pariatur excepteur aute amet cillum voluptate ipsum."),
          const TextSpan(text: "\n"),
          const TextSpan(text: "ID: "),
          TextSpan(text: "$i"),
        ])),
      ));*/
      output.add(Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.amber,
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const Text("Nombre"), Text("$i")],
          ),
        ),
      ));
    }
    return output;
  }

  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    /* return const SingleChildScrollView(
      child: FormBuilderWidget(
          pzInsKey:
              "ASSIGN-WORKLIST CF-FW-INTERPRE-WORK R-4017!TERMSCONDITIONS"),
    );*/

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton(
            hint: Text("asda"),
            items: [
              DropdownMenuItem(
                child: Text("1"),
                value: "x",
              ),
              DropdownMenuItem(child: Text("2"), value: "y"),
            ],
            value: "3",
            onChanged: (value) {
              print("x");
            },
          )
        ],
      ),
    ));
  }
}
