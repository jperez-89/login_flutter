import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/widgets.dart';

class NewInterpreterAsignment extends StatefulWidget {
  const NewInterpreterAsignment({Key? key}) : super(key: key);

  @override
  State<NewInterpreterAsignment> createState() =>
      _NewInterpreterAsignmentState();
}

class _NewInterpreterAsignmentState extends State<NewInterpreterAsignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Interpreter'),
        ),
        body: const Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                FormBuilderWidget(),
              ],
            ),
          ),
        ));
  }
}
