import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_flutter/models/actions/assignment_actions.dart';
import 'package:login_flutter/models/actions/case_actions.dart';
import 'package:login_flutter/widgets/widgets.dart';

class NewAssignmentScreen extends StatefulWidget {
  const NewAssignmentScreen({super.key});

  @override
  State<NewAssignmentScreen> createState() => _NewAssignmentScreenState();
}

class _NewAssignmentScreenState extends State<NewAssignmentScreen> {
  String caseTypeID = '',
      name = '.',
      assignmentId = '',
      pzInsKey = '',
      actionID = '',
      nextAssignmentID = '';
  List components = [];
  Map<String, String> frmData = {};
  Map<String, dynamic> json = {};

  createCase(Map classID) async {
    caseTypeID = classID['classID'].toString();
    name = classID['name'].toString();

    await CaseActions().createCase(caseTypeID).then((value) {
      setState(() {
        List split = value['ID'].split(' ');
        assignmentId = split[1];
        pzInsKey = value['nextAssignmentID'];
      });
    });
  }

  saveData(Map data) async {
    setState(() {
      frmData = data['data'];
      assignmentId = data['assignmentID'];
      actionID = data['actionID'];
    });

    await AssignmentActions()
        .saveAssignment(assignmentId, actionID, frmData)
        .then((value) async {
      if (value.statusCode == 200) {
        json = jsonDecode(value.body);
        nextAssignmentID = json['nextAssignmentID'];

        await refreshAssignment(nextAssignmentID, assignmentId);
      } else {
        print('ERROR OBTENER POST INFORMACION');
        print(value.statusCode);
        print(value.body);
      }
    });
  }

  refreshAssignment(String nextAssignmentID, String? id) async {
    await AssignmentActions().getAssignment(nextAssignmentID).then((value) {
      setState(() {
        actionID = nextAssignmentID;
        components = value["components"];
        pzInsKey = nextAssignmentID;
        name = value["components"][0]['caption']['value'];
        assignmentId = id!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    if (args['option'] == 'newCase') {
      if (pzInsKey == '') {
        print('new');
        createCase(args);
      }
    } else if (args['option'] == 'getView') {
      if (actionID == '') {
        print('getV');
        refreshAssignment(args['pzInsKey'], args['assignmentId']);
      }
    } else if (args['option'] == 'saveData') {
      if (actionID == '') {
        print('save');
        saveData(args);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: pzInsKey != '' ? Text('$name $assignmentId') : const Text(''),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: pzInsKey != ''
            ? Column(
                children: [
                  FormBuilderWidget(pzInsKey: pzInsKey),
                ],
              )
            : const Column(
                children: [
                  LinearProgressIndicator()
                  // CircularProgressIndicator.adaptive()
                ],
                //       ),
              ),
      ),
    );
  }
}
