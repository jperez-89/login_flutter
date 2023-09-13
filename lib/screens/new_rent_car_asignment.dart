import 'package:flutter/material.dart';

class NewRentCarAsignment extends StatelessWidget {
  const NewRentCarAsignment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Card'),
      ),
      body: const Center(
        child: Text('New Rent Card'),
      ),
    );
  }
}
