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

      final urlAssignment = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey');

      final httpPackageResponse = await get(urlAssignment, headers: headers);

      Map<String, dynamic> json = jsonDecode(httpPackageResponse.body);

      String actionsID = json['actions'][0]['ID'];

      Map<String, dynamic> actionButtons =
          json['actionButtons']["secondary"][1];

      final urlAssignmentActionID = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['ASSIGNMENTS']}/$pzInsKey${endpoints['ACTIONS']}/$actionsID');
      //print(urlAssignmentActionID);

      final httpPackageResponseData =
          await get(urlAssignmentActionID, headers: headers);

      return {
        "components": httpPackageResponseData,
        "actionButtons": actionButtons
      };
    }
  }
}
