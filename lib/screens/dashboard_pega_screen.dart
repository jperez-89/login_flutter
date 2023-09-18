import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/drawer.dart';
import 'package:login_flutter/widgets/worklist.dart';

class DashboardPegaScreen extends StatefulWidget {
  const DashboardPegaScreen({Key? key}) : super(key: key);

  @override
  State<DashboardPegaScreen> createState() => _DashboardPegaScreenState();
}

class _DashboardPegaScreenState extends State<DashboardPegaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(title: const Text('Dashboard'), actions: [
        Container(
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
                onPressed: () {
                  // getCaseType();
                },
                child: const CircleAvatar(
                  child: Text('I'),
                )))
      ]),
      body: const WorklistWidget(),
      // body: const SingleChildScrollView(
      //   child: Expanded(
      //     // child: Text('Hola'),
      //     child: WorklistWidget(),
      //   ),
      // ),
    );
  }
}
