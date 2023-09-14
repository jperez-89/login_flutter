import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/widgets.dart';

class NewRentCarAsignment extends StatelessWidget {
  const NewRentCarAsignment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rent Card'),
        ),
        body: const Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [FormBuilderWidget()],
            ),
          ),
        ));
  }
}
