import 'package:flutter/material.dart';
import 'package:login_flutter/widgets/drawer.dart';

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
        body: const Center(
            child: Column(children: [
          // TextButton(
          //     onPressed: () {
          //       PegaConection()
          //           .conexion(urlAssignments, 'InterpreterOP', 'hyopJK77@')
          //           .then((value) {
          //         body = value.body;
          //         setState(() {});
          //       });
          //     },
          //     child: const Text('Ver Assignments')),
          Expanded(
            child: Text('Hola'),
          )
        ])));
  }
}
