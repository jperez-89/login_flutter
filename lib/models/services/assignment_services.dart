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

<<<<<<< HEAD
      final url1 = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey');

      final httpPackageResponse = await get(url1, headers: headers);
=======
      final urlAssignment = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey');

      final httpPackageResponse = await get(urlAssignment, headers: headers);
>>>>>>> 93eef08a9ba9371cd788cce6ef5e8b0acdb350d1

      Map<String, dynamic> json = jsonDecode(httpPackageResponse.body);

      final split = json['caseID'].split(' ');
      final caseID = split[1];

      String actionsID = json['actions'][0]['ID'];

<<<<<<< HEAD
      final url2 = Uri.parse(
=======
      Map<String, dynamic> actionButtons =
          json['actionButtons']["secondary"][1];

      final urlAssignmentActionID = Uri.parse(
>>>>>>> 93eef08a9ba9371cd788cce6ef5e8b0acdb350d1
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey${endpoints['ACTIONS']}/$actionsID');
      //print(urlAssignmentActionID);

<<<<<<< HEAD
      final httpPackageResponseData = await get(url2, headers: headers);
=======
      final httpPackageResponseData =
          await get(urlAssignmentActionID, headers: headers);
>>>>>>> 93eef08a9ba9371cd788cce6ef5e8b0acdb350d1

      return {
        "components": httpPackageResponseData,
        "actionsID": actionsID,
        'caseID': caseID
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

      List pageInstructions = [];

      final Map<String, String> headers = {
        'Accept': "application/json, text/plain, */*",
        'Content-type': 'application/json',
        'Authorization': basicAuth,
      };

      final httpPackcageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$assignmentID?actionID=$actionID');

      final bodyData =
          '{"content": "$body", "pageInstructions": $pageInstructions}';

      final httpPackageResponse =
          await post(httpPackcageUrl, headers: headers, body: bodyData);

      // print(' Save Assignment');
      // print(httpPackageResponse.statusCode);
      // print(httpPackageResponse.body);
      // print(' Fin Assignment');

      return httpPackageResponse;
    }
  }
}
