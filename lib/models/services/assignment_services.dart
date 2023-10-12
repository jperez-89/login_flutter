import 'dart:convert';
import 'package:login_flutter/models/services/endpoints.dart';
import 'package:login_flutter/models/services/service.dart';

class AssignmentService {
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
      // final caseID = jsonData['content']['pxInsName']; // name = I-1001

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

  Future saveAssignment(
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

      final Map<String, String> headers = {
        'Accept': "application/json, text/plain, */*",
        'Content-type': 'application/json',
        'Authorization': basicAuth,
      };

      final httpPackcageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$assignmentID?actionID=$actionID&saveOnly=true');

      String jsonBody = jsonEncode(body);
      final String bodyData = '{"content": $jsonBody}';

      final httpPackageResponse =
          await post(httpPackcageUrl, headers: headers, body: bodyData);

      return httpPackageResponse;
    }
  }

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

  /// Funcion para setear los beneficiarios
  /// @param pzInsKey
  /// @param actions
  /// @param body
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

      // print(httpPackageResponse.statusCode);
      // print(httpPackageResponse.headers);
      // print(httpPackageResponse.request);
      // print(httpPackageResponse.body);

      return httpPackageResponse;
    }
  }
}
