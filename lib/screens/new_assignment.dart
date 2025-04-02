import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_flutter/widgets/widgets.dart';
import 'package:login_flutter/models/actions/case_actions.dart';
import 'package:login_flutter/models/actions/assignment_actions.dart';

class NewAssignmentScreen extends StatefulWidget {
  const NewAssignmentScreen({super.key});

  @override
  State<NewAssignmentScreen> createState() => _NewAssignmentScreenState();
}

class _NewAssignmentScreenState extends State<NewAssignmentScreen> {
  String caseTypeID = '',
      name = '',
      assignmentId = '',
      pzInsKey = '',
      actionID = '',
      nextAssignmentID = '';
  List components = [];
  Map<String, String> frmData = {};
  Map<String, dynamic> json = {};
  Map args = {};
  bool load = false;

  /// Se accede a la accion que ejecuta el servicio para crear un nuevo caso
  /// Params
  /// @ClassID
  createCase(Map classID) async {
    caseTypeID = classID['classID'].toString();
    name = classID['name'].toString();

    trueLoading();

    await CaseActions().createCase(caseTypeID).then((value) {
      setState(() {
        List split = value['ID'].split(' ');
        assignmentId = split[1];
        pzInsKey = value['nextAssignmentID'];
      });
    });

    falseLoading();
  }

  /// Se accede a la accion que ejecuta el servicio para guardar informacion actual del caso
  /// Params
  /// @data -> Mapa con pzInsKey, actionID y la data
  saveData(Map data) async {
    assignmentId = data['assignmentID'];
    actionID = data['actionID'];
    frmData = data['data'];

    trueLoading();

    await AssignmentActions()
        .saveAssignment(assignmentId, actionID, frmData)
        .then((value) {
      ///Esto es para sacar el titulo de la pantalla
      List split = assignmentId.split(' ');
      split = split[2].split('!');

      if (value.statusCode == 200) {
        showMessage('Success', 'Datos guardados');

        setState(() {
          pzInsKey = assignmentId;
          name = split[0]; //Titulo
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
            name = split[0];
          });
        }
      } else {
        showMessage(value.statusCode, value.body);
      }

      falseLoading();
    });
  }

  /// Se accede a la accion que ejecuta el servicio para guardar informacion actual del caso y pasar al siguiente Step
  /// Params
  /// @data - Mapa con pzInsKey, actionID y la data
  submitData(Map data) async {
    assignmentId = data['assignmentID'];
    actionID = data['actionID'];
    frmData = data['data'];

    trueLoading();

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
          name = split2[0];
          pzInsKey = nextAssignmentID;
        });
      } else if (value.statusCode == 400) {
        json = jsonDecode(value.body);

        final errors = json;
        final validationMessages = errors['ValidationMessages'];

        showMessage('Errores', validationMessages);
      } else {
        print(value.body);
        showMessage('Revisar Consola', value.statusCode.toString());
      }

      falseLoading();
    });
  }

  /// Se actualiza el estado de los parametros para obtener la vista del caso
  /// Params
  /// @data - Mapa con pzInsKey y assignmentId
  getView(Map data) async {
    trueLoading();

    setState(() {
      pzInsKey = data['pzInsKey'];
      assignmentId = data['assignmentId'];
    });

    falseLoading();
  }

  /// Funcion para mostrar mensajes
  /// Params
  /// @title - Titulo del mensaje
  /// @message - Cuerpo del mensaje
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

  trueLoading() {
    // await Future.delayed(const Duration(seconds: 1));
    setState(() {
      load = true;
    });
  }

  falseLoading() {
    // await Future.delayed(const Duration(seconds: 1));
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos los datos pasados por argumentos
    args = ModalRoute.of(context)!.settings.arguments as Map;

    // /// Se validan las diferentes opciones para acceder a los metodos
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
        if (pzInsKey == '') {
          saveData(args);
        }
        break;
      case 'SubmitData':
        if (pzInsKey == '') {
          submitData(args);
        }
        break;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (pzInsKey != '' || actionID != '')
            ? Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              )
            : const Text(''),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: (load)
            ? Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 300),
                child: const CircularProgressIndicator.adaptive(),
              )
            : Column(
                children: [
                  FormBuilderWidget(pzInsKey: pzInsKey),
                ],
              ),
      ),
    );
  }
}
