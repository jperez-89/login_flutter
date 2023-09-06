import 'package:flutter/material.dart';
import 'package:ch_color_ab/ch_color_ab.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  late Color colorAppBar = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppBar,
        title: const Text('Welcome to Paradise'),
      ),
      body: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colorAppBar),
            onPressed: () {
              colorAppBar = ChangeColor().change();
              setState(() {});
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Change color to App',
                style: TextStyle(fontSize: 16),
              ),
            )),
      ),
    );
  }
}
