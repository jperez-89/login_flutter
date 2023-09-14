import 'dart:convert';

import 'package:login_flutter/models/services/assignment_services.dart';

class AssignmentActions {
  List componentes = [];

  getAssignment() {
    return AssignmentService().getAssignment().then((value) {
      Map<String, dynamic> json = jsonDecode(value.body);
      extractComponents(json["view"]["groups"] ?? []);
      return componentes;
    });
  }

  void extractComponents(List<dynamic> respuesta) {
    for (var i = 0; i < respuesta.length; i++) {
      pelarCebolla(respuesta[i]);
    }
  }

  void pelarCebolla(Map<String, dynamic> cebolla) {
    if (cebolla.containsKey("layout")) {
      if (cebolla["layout"].containsKey("groups")) {
        extractComponents(cebolla["layout"]["groups"]);
      }
    } else {
      componentes.add(cebolla);
    }
  }
}
