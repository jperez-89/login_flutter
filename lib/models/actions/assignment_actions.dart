import 'dart:convert';
import 'package:login_flutter/models/services/assignment_services.dart';

class AssignmentActions {
  List componentes = [];
  List labelButtons = [];

  getAssignment(String pzInsKey) {
    return AssignmentService().getAssignment(pzInsKey).then((value) {
      Map<String, dynamic> json = jsonDecode(value["components"].body);

      extractComponents(json["view"]["groups"] ?? []);
      return {
        "components": componentes,
        "actionID": value["actionsID"],
        'data': value['data'],
        'labelButtons': getLabelButton(value["actionsButtons"])
      };
    });
  }

  saveAssignment(
      String assignmentID, String actionID, Map<String, String> body) {
    return AssignmentService()
        .saveAssignment(assignmentID, actionID, body)
        .then((value) {
      return value;
    });
  }

  submitAssignment(
      String assignmentID, String actionID, Map<String, String> body) {
    return AssignmentService()
        .submitAssignment(assignmentID, actionID, body)
        .then((value) {
      return value;
    });
  }

  refreshAssignment(String pzInskey, String actionID, List actionRefresh,
      Map<String, String> body) async {
    return await AssignmentService()
        .refreshAssignment(pzInskey, actionID, actionRefresh, body)
        .then((value) {
      if (value.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(value.body);
        extractComponents(json["view"]["groups"] ?? []);
      } else {
        print('Error Codigo => ${value.statusCode}');
      }

      return {
        "components": componentes,
      };
    });
  }

  void extractComponents(List<dynamic> respuesta) {
    for (var i = 0; i < respuesta.length; i++) {
      getFields(respuesta[i]);
    }
  }

  void getFields(Map<String, dynamic> fields) {
    if (fields.containsKey("layout")) {
      if (fields["layout"].containsKey("groups")) {
        extractComponents(fields["layout"]["groups"]);
      } else if (fields["layout"].containsKey("header")) {
        componentes.add({'pxTable': fields['layout']});
      }
    } else {
      componentes.add(fields);
    }
  }

// Obtener label para los botones
  List getLabelButton(Map acttionButton) {
    String save = '';
    String submit = '';
    String cancel = '';

    if (acttionButton.containsKey("secondary")) {
      for (var i = 0; i < acttionButton["secondary"].length; i++) {
        if (acttionButton['secondary'][i]['actionID'] == 'cancel') {
          cancel = acttionButton['secondary'][i]['actionID'];
        } else if (acttionButton['secondary'][i]['actionID'] == 'save') {
          save = acttionButton['secondary'][i]['actionID'];
        }
      }
      labelButtons.add(save);
      labelButtons.add(cancel);
    }

    if (acttionButton.containsKey("main")) {
      for (var i = 0; i < acttionButton["main"].length; i++) {
        if (acttionButton['main'][i]['actionID'] == 'submit') {
          submit = acttionButton['main'][i]['name'];
        }
        labelButtons.add(submit);
      }
    }

    return labelButtons;
  }
}
