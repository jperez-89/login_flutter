import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_flutter/models/actions/case_actions.dart';
import 'package:login_flutter/theme/app_theme.dart';
import 'package:login_flutter/widgets/drawer.dart';
import 'package:login_flutter/widgets/worklist.dart';

class DashboardPegaScreen extends StatefulWidget {
  const DashboardPegaScreen({Key? key}) : super(key: key);

  @override
  State<DashboardPegaScreen> createState() => _DashboardPegaScreenState();
}

class _DashboardPegaScreenState extends State<DashboardPegaScreen> {
  List<dynamic> lst = [];
  bool service = true;

// Obtiene los caseType para pasarlos al drawert
  getCaseType() async {
    await CaseActions().getCaseType().then((value) {
      if (value.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(value.body);
        setState(() {
          lst = json['caseTypes'];
        });
      } else if (value.statusCode == 503) {
        setState(() {
          service = false;
        });
      }
    });
  }

  @override
  void initState() {
    getCaseType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppTheme.primaryColor,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ]),
      drawer: DrawerWidget(lst: lst, service: service),
      appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: const Text('Dashboard'),
          actions: [
            Container(
                // color: AppTheme.primaryColor,
                margin: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppTheme.primaryColor)),
                    onPressed: () {
                      // getCaseType();
                    },
                    child: const CircleAvatar(
                      backgroundColor: AppTheme.secondaryColor,
                      child: Text('I'),
                    )))
          ]),
      body: const WorklistWidget(),
    );
  }
}
