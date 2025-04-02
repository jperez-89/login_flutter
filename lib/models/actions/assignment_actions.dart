import 'dart:convert';
import 'package:login_flutter/models/services/assignment_services.dart';

class AssignmentActions {
  List componentes = [];
  List labelButtons = [];

  /// Envia los parametros al servicio y obtiene el json de los diferentes formularios desde pega por medio del pzInsKey
  /// Params
  /// @pzInsKey -> ID del caso, eje: ASSIGN-WORKLIST%20CF-FW-INTERPRE-WORK%20I-4!BENEFICIARIES
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

  /// Envia los parametros al services para guarda la informacion actual del formulario en pega y retorna la vista con dicha informacion
  /// Params
  /// @pzInsKey
  /// @actionID -> Flow del caso eje: CustomerBeneficiaries
  /// @body -> datos a guardar
  saveAssignment(String pzInsKey, String actionID, Map<String, String> body) {
    return AssignmentService()
        .saveAssignment(pzInsKey, actionID, body)
        .then((value) {
      return value;
    });
  }

  /// Envia los parametros al services para guarda la informacion actual del formulario en pega, retorna el pzInsKey del siguiente Step para obtener la vista de dicho formulario
  /// Params
  /// @pzInsKey
  /// @actionID -> Flow del caso eje: CustomerBeneficiaries
  /// @body -> datos a guardar
  submitAssignment(String pzInsKey, String actionID, Map<String, String> body) {
    return AssignmentService()
        .submitAssignment(pzInsKey, actionID, body)
        .then((value) {
      return value;
    });
  }

  /// Envia los parametros al services para hacer una actualizacion de pantalla, se utiliza principalmente en el agregado de beneficiarios
  /// Params
  /// @pzInsKey
  /// @actionID -> Flow del caso eje: CustomerBeneficiaries
  /// @actionRefresh -> Codigo necesario para hacer el PUT
  /// @body -> datos a guardar
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

  /// Envia los datos del json a la funcion getFields
  void extractComponents(List<dynamic> respuesta) {
    for (var i = 0; i < respuesta.length; i++) {
      getFields(respuesta[i]);
    }
  }

  /// Descompone el json segun sea necesario
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

// Obtiene, del json que retorna pega, los label para los botones principales del formulario (save, cancel, submit)
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
