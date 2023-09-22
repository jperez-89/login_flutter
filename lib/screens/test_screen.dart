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
      body: Column(children: [generarRadioButtons()]),
    );
  }
}
