import 'dart:convert';
import 'package:login_flutter/models/services/assignment_services.dart';

class AssignmentActions {
  List componentes = [];

  getAssignment(String pzInsKey) {
    return AssignmentService().getAssignment(pzInsKey).then((value) {
      Map<String, dynamic> json = jsonDecode(value["components"].body);

      extractComponents(json["view"]["groups"] ?? []);
      return {
        "components": componentes,
        "actionID": value["actionsID"],
        'data': value['data'],
        'actionsButtons': value["actionsButtons"]
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
      }
    } else {
      componentes.add(fields);
    }
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
        .saveAssignment(assignmentID, actionID, body)
        .then((value) {
      return value;
    });
  }
}
