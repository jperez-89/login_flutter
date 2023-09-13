import 'package:flutter/material.dart';

class NewInterpreterAsignment extends StatelessWidget {
  const NewInterpreterAsignment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Interpreter'),
      ),
      body: const Center(
        child: Text('Interpreter'),
      ),
    );
  }
}
