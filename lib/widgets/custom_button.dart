import 'package:flutter/material.dart';
import 'package:login_flutter/models/actions/assignment_actions.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final String actionID;
  final List actionSets;
  final String pzInsKey;
  final Map<String, String> frmValues;
  final GlobalKey<FormState> myFormKey;
  final Function update;

  const CustomButton({
    Key? key,
    required this.label,
    required this.actionSets,
    required this.pzInsKey,
    required this.frmValues,
    required this.myFormKey,
    required this.actionID,
    required this.update,
  }) : super(key: key);

  // Ejecutamos la accion del boton
  setBeneficiaries(String pzIsnKey, String actionID, List actionRefresh,
      Map<String, String> body, BuildContext context) async {
    await AssignmentActions()
        .refreshAssignment(pzInsKey, actionID, actionRefresh, body)
        .then((value) {
      if (value["components"] != '') {
        List components = value["components"];

        // Actualizamos la pantalla
        update(components);

        // REVISAR COMO PINTAR LA CARD
        // Map json = jsonDecode(value.body);
        // List split = json['caseID'].split(' ');
        // String assignmentID = split[1];

        // Navigator.pushNamed(context, 'newAssigment', arguments: {
        //   'option': 'setView',
        //   'assignmentId': assignmentID,
        //   'pzInsKey': pzInsKey,
        //   'body': json
        // });
      } else {
        showMessage('Error', 'Codigo ${value.statusCode} Mapa vacio', context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => {
              if (!myFormKey.currentState!.validate())
                {showMessage('Error', 'Complete todos los campos', context)}
              else
                {
                  setBeneficiaries(
                      pzInsKey, actionID, actionSets, frmValues, context)
                }
            },
        child: Text(label));
  }
}

void showMessage(String title, String message, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [Text(message)],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'))
          ],
        );
      });
}
