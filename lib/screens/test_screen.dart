import 'package:flutter/material.dart';
// import 'package:login_flutter/widgets/widgets.dart';

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
            "$titulo",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "$valor",
          )
        ],
      ),
    );
  }

  List<Widget> x() {
    List<Widget> output = [];
    for (var i = 0; i < 10; i++) {
      output.add(currencyInput("$i", "Laboris exercitation "));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;

    // return const SingleChildScrollView(
    //   child: FormBuilderWidget(
    //       pzInsKey:
    //           "ASSIGN-WORKLIST CF-FW-INTERPRE-WORK R-4017!TERMSCONDITIONS"),
    // );

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(' '),
        ),
        body: Center(
          child: Card(
            // shadowColor: AppTheme.primaryColor.withOpacity(0.8),
            margin: const EdgeInsets.all(0),
            elevation: 10,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [Text(args['body'])],
              ),
            ),
          ),
        ));
  }
}
