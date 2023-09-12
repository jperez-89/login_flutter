import 'package:flutter/material.dart';
import 'package:login_flutter/models/services/endpoints.dart';
import 'package:login_flutter/models/services/pega_conection.dart';
import 'package:login_flutter/models/actions/case_actions.dart';

class DashboardPegaScreen extends StatefulWidget {
  const DashboardPegaScreen({Key? key}) : super(key: key);

  @override
  State<DashboardPegaScreen> createState() => _DashboardPegaScreenState();
}

class _DashboardPegaScreenState extends State<DashboardPegaScreen> {
  late String body = '';

  void getCaseType() {
    CaseActions().getCaseType().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    String urlAssignments =
        '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {
                  getCaseType();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blue[900],
                  child: const Text('I'),
                ),
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  PegaConection()
                      .conexion(urlAssignments, 'InterpreterOP', 'hyopJK77@')
                      .then((value) {
                    body = value.body;
                    setState(() {});
                  });
                },
                child: const Text('Ver Assignments')),
            Expanded(
              child: SingleChildScrollView(
                child: Text(body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
