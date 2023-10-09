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
}
