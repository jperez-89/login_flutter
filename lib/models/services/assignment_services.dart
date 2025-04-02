import 'dart:convert';
import 'package:login_flutter/models/services/endpoints.dart';
import 'package:login_flutter/models/services/service.dart';

class AssignmentService {
  /// Envia los parametros al services de Pega y obtiene el json de los diferentes formularios desde pega por medio del pzInsKey
  /// Params
  /// #pzInsKey -> ID del caso, eje: ASSIGN-WORKLIST%20CF-FW-INTERPRE-WORK%20I-4!BENEFICIARIES
  Future getAssignment(String pzInsKey) async {
    String user = 'InterpreterOP';
    String pass = 'hyopJK77@';

    if (endpoints['use_OAuth']) {
      // return authLogin().then((token) => {
      //   if (token) {
      //     userService.setToken(token);
      //     // Route to workarea as well if popup (callback only happens on popup scenario
      //   }
      // });
    } else {
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$user:$pass'))}';

      final Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': basicAuth
      };
      /* ********* OBTENER ACCIONES DE LOS BOTONES ********* */
      final urlGetActions = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey');

      Response getActions = await get(urlGetActions, headers: headers);

      Map<String, dynamic> jsonActions = jsonDecode(getActions.body);
      String actionsID = jsonActions['actions'][0]['ID']; // interpreteflow
      String caseID = jsonActions['caseID']; // CF-FW-INTERPRE-WORK I-3
      Map actionsButtons = jsonActions['actionButtons'];

      /* ********* OBTENER DATOS DEL STEP ACTUAL, SI LOS TIENE ********* */
      final urlGetData = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['CASES']}/$caseID');

      Response getData = await get(urlGetData, headers: headers);

      Map<String, dynamic> jsonData = jsonDecode(getData.body);

      /* ********* OBTENER FORMULARIO DEL STEP ACTUAL ********* */
      final urlGetFormView = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey${endpoints['ACTIONS']}/$actionsID');

      Response getFormView = await get(urlGetFormView, headers: headers);

      return {
        "components": getFormView,
        "actionsID": actionsID,
        'data': jsonData,
        'actionsButtons': actionsButtons
      };
    }
  }

  /// Envia los parametros al services de Pega para guarda la informacion actual del formulario en pega y retorna la vista con dicha informacion
  /// Params
  /// @pzInsKey
  /// @actionID -> Flow del caso eje: CustomerBeneficiaries
  /// @body -> datos a guardar
  Future saveAssignment(
      String pzInsKey, String actionID, Map<String, String> body) async {
    String user = 'InterpreterOP';
    String pass = 'hyopJK77@';

    if (endpoints['use_OAuth']) {
      // return authLogin().then((token) => {
      //   if (token) {
      //     userService.setToken(token);
      //     // Route to workarea as well if popup (callback only happens on popup scenario
      //   }
      // });
    } else {
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$user:$pass'))}';

      final Map<String, String> headers = {
        'Accept': "application/json, text/plain, */*",
        'Content-type': 'application/json',
        'Authorization': basicAuth,
      };

      final httpPackcageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey?actionID=$actionID&saveOnly=true');

      String jsonBody = jsonEncode(body);
      final String bodyData = '{"content": $jsonBody}';

      final httpPackageResponse =
          await post(httpPackcageUrl, headers: headers, body: bodyData);

      return httpPackageResponse;
    }
  }

  /// Envia los parametros al services de Pega para guarda la informacion actual del formulario en pega, retorna el pzInsKey del siguiente Step para obtener la vista de dicho formulario
  /// Params
  /// @pzInsKey
  /// @actionID -> Flow del caso eje: CustomerBeneficiaries
  /// @body -> datos a guardar
  Future submitAssignment(
      String assignmentID, String actionID, Map<String, String> body) async {
    String user = 'InterpreterOP';
    String pass = 'hyopJK77@';

    if (endpoints['use_OAuth']) {
      // return authLogin().then((token) => {
      //   if (token) {
      //     userService.setToken(token);
      //     // Route to workarea as well if popup (callback only happens on popup scenario
      //   }
      // });
    } else {
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$user:$pass'))}';
      List pageInstructions = [];

      final Map<String, String> headers = {
        'Accept': "application/json, text/plain, */*",
        'Content-type': 'application/json',
        'Authorization': basicAuth,
      };

      final httpPackcageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$assignmentID?actionID=$actionID');

      String jsonBody = jsonEncode(body);

      final bodyData =
          '{"content": $jsonBody, "pageInstructions": $pageInstructions}';

      final httpPackageResponse =
          await post(httpPackcageUrl, headers: headers, body: bodyData);

      return httpPackageResponse;
    }
  }

  /// Envia los parametros al services para hacer una actualizacion de pantalla, se utiliza principalmente en el agregado de beneficiarios
  /// Params
  /// @pzInsKey
  /// @actionID -> Flow del caso eje: CustomerBeneficiaries
  /// @actionRefresh -> Codigo necesario para hacer el PUT
  /// @body -> datos a guardar
  Future refreshAssignment(String pzInsKey, String actionID, List actionRefresh,
      Map<String, String> body) async {
    String user = 'InterpreterOP';
    String pass = 'hyopJK77@';

    if (endpoints['use_OAuth']) {
      // return authLogin().then((token) => {
      //   if (token) {
      //     userService.setToken(token);
      //     // Route to workarea as well if popup (callback only happens on popup scenario
      //   }
      // });
    } else {
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$user:$pass'))}';
      final List pageInstructions = [];

      final Map<String, String> headers = {
        'Accept': "application/json, text/plain, */*",
        'Content-type': 'application/json',
        'Authorization': basicAuth,
      };

      final Map<String, dynamic> params = {
        'refreshFor': '${actionRefresh[0]["refreshFor"]}'
      };

      final httpPackcageUrl = Uri.https(
          endpoints['DOMAIN'],
          '${endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey${endpoints['ACTIONS']}/$actionID${endpoints['REFRESH']}',
          params);

      String jsonBody = jsonEncode(body);

      final bodyData =
          '{"content": $jsonBody, "pageInstructions": $pageInstructions}';

      final httpPackageResponse =
          await put(httpPackcageUrl, headers: headers, body: bodyData);

      // Posibles Impresiones que se pueden hacer
      // print(httpPackageResponse.statusCode);
      // print(httpPackageResponse.headers);
      // print(httpPackageResponse.request);
      // print(httpPackageResponse.body);

      return httpPackageResponse;
    }
  }
}
