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

      final url1 = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey');

      final httpPackageResponse = await get(url1, headers: headers);

      Map<String, dynamic> json = jsonDecode(httpPackageResponse.body);

      final split = json['caseID'].split(' ');
      final caseID = split[1];

      String actionsID = json['actions'][0]['ID'];

      final url2 = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey${endpoints['ACTIONS']}/$actionsID');
      //print(urlAssignmentActionID);

      final httpPackageResponseData = await get(url2, headers: headers);

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
        'Content-type': 'application/json',
        // 'content-type': 'text/plain',
        'Accept': "*/*",
        'Authorization': basicAuth,
      };

      final httpPackcageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$assignmentID?actionID=$actionID');

      // print('httpPackcageUrl');
      // print(body);

      final bodyData =
          '{"content": "$body", "pageInstructions": $pageInstructions}';

      // final Map bodyData = {'content': body, 'pageInstructions': pageInstructions};

      // print('bodyData');
      // print(bodyData.toString());
      // print(bodyData);

      final httpPackageResponse =
          await post(httpPackcageUrl, headers: headers, body: bodyData);

      print('====> Save Assignment');
      print(httpPackageResponse.statusCode);
      print(httpPackageResponse.body);
      print('====> Fin Assignment');

      return httpPackageResponse;
    }
  }
}
