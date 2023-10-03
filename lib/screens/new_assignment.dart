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
      List split = assignmentId.split(' ');
      split = split[2].split('!');

      if (value.statusCode == 200) {
        showMessage('Success', 'Datos guardados');
        setState(() {
          pzInsKey = assignmentId;
          assignmentId = split[0];
        });
      } else if (value.statusCode == 400) {
        Map json = jsonDecode(value.body);
        List errors = json['errors'];

        if (errors.isNotEmpty) {
          List validationMessages = errors[0]['ValidationMessages'];
          Map errMessage = {};
          // String errMessage = '';
          // Map ss = validationMessages[0];

          for (var i = 0; i < validationMessages.length; i++) {
            if (validationMessages[i].containsKey('Path')) {
              errMessage.addAll({
                validationMessages[i]['Path']: validationMessages[i]
                    ['ValidationMessage']
              });
              // errMessage += validationMessages[i]['ValidationMessage'] + ' ';
            }
          }
          showMessage('Errors', errMessage.toString());
          setState(() {
            pzInsKey = assignmentId;
            assignmentId = split[0];
          });
        }
      } else {
        showMessage(value.statusCode, value.body);
      }
    });
  }

  submitData(Map data) async {
    assignmentId = data['assignmentID'];
    actionID = data['actionID'];
    frmData = data['data'];

    await AssignmentActions()
        .submitAssignment(assignmentId, actionID, frmData)
        .then((value) async {
      if (value.statusCode == 200) {
        json = jsonDecode(value.body);
        nextAssignmentID = json['nextAssignmentID'];

        List split = assignmentId.split(' '); // CF-FW-INTERPRE-WORK
        List split2 = split[2].split('!'); // I-2002

        showMessage('Success', 'Datos guardados');
        setState(() {
          actionID = nextAssignmentID;
          assignmentId = split2[0];
          pzInsKey = nextAssignmentID;
        });
      } else if (value.statusCode == 400) {
        json = jsonDecode(value.body);
        print(json);

        final errors = json;
        final validationMessages = errors['ValidationMessages'];

        showMessage('Errores', validationMessages);
      } else {
        showMessage('Revisar Consola', value.statusCode);
        print(value.body);
      }
    });
  }

  getView(Map data) {
    setState(() {
      pzInsKey = data['pzInsKey'];
      assignmentId = data['assignmentId'];
      name = data['name'];
    });
  }

  void showMessage(String title, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ), // Titulo de la card
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ajusta la card al texto mas pequenho
              children: [
                Text(message),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;
    switch (args['option']) {
      case 'newCase':
        if (pzInsKey == '') {
          createCase(args);
        }
        break;
      case 'getView':
        if (pzInsKey == '') {
          getView(args);
        }
        break;
      case 'SaveData':
        if (actionID == '') {
          saveData(args);
        }
        break;
      case 'SubmitData':
        if (actionID == '') {
          submitData(args);
        }
        break;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: pzInsKey != ''
            ? Text(
                assignmentId,
                style: const TextStyle(fontWeight: FontWeight.w700),
              )
            : const Text(' '),
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
                children: [LinearProgressIndicator()],
                //       ),
              ),
      ),
    );
  }
}
