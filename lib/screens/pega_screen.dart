import 'package:flutter/material.dart';
import 'package:login_flutter/models/services/pega_conection.dart';

class PegaScreen extends StatelessWidget {
  const PegaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  PegaConection()
                      .conexion('asa', 'as', 'sa')
                      .then((value) => print(value));
                },
                child: const Text('Auth')),
          ],
        ),
      ),
    );
  }
}
