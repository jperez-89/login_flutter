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
    assignmentId = data['assignmentID'];
    actionID = data['actionID'];
    frmData = data['data'];

    await AssignmentActions()
        .saveAssignment(assignmentId, actionID, frmData)
        .then((value) {
      if (value.statusCode == 200) {
        print('FUNCTION SCREE SUCCESS');
        print(value.body);
      } else {
        print('FUNCTION SCREE ERROR');
        print(value.statusCode);
        print(value.body);
      }
    });
  }

  submitData(Map data) async {
    // print('DATA IN SCREEN');
    // print(data);
    // setState(() {
    assignmentId = data['assignmentID'];
    actionID = data['actionID'];
    frmData = data['data'];
    // });

    await AssignmentActions()
        .submitAssignment(assignmentId, actionID, frmData)
        .then((value) async {
      if (value.statusCode == 200) {
        json = jsonDecode(value.body);
        nextAssignmentID = json['nextAssignmentID'];

        await refreshAssignment(nextAssignmentID, assignmentId);
      } else if (value.statusCode == 400) {
        print('ERRORES EN INPUTS');

        json = jsonDecode(value.body);
        print(json);

        // final errors = json;
        // final validationMessages = errors['ValidationMessages'];

        // print(errors);
      } else {
        print('ERROR OBTENER POST INFORMACION');
        print(value.statusCode);
        print(value.body);
      }
    });
  }

  refreshAssignment(String nextAssignmentID, String? id) async {
    await AssignmentActions().getAssignment(nextAssignmentID).then((value) {
      actionID = nextAssignmentID;
      components = value["components"];
      pzInsKey = nextAssignmentID;
      name = value["components"][0]['caption']['value'];
      assignmentId = id!;
      setState(() {});
    });
  }

  getView(Map data) {
    setState(() {
      pzInsKey = data['pzInsKey'];
      assignmentId = data['assignmentId'];
      name = data['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    switch (args['option']) {
      case 'newCase':
        if (pzInsKey == '') {
          print('newCase');
          createCase(args);
        }
        break;
      case 'getView':
        if (pzInsKey == '') {
          print('getView');
          getView(args);
        }
        break;
      case 'SaveData':
        if (actionID == '') {
          print('SaveData');
          saveData(args);
        }
        break;
      case 'SubmitData':
        if (actionID == '') {
          print('SubmitData');
          submitData(args);
        }
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: pzInsKey != '' ? Text('$name $assignmentId') : const Text(' '),
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
