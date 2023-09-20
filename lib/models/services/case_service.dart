import 'dart:convert';
import 'package:login_flutter/models/services/endpoints.dart';
import 'package:login_flutter/models/services/service.dart';

class CaseService {
  Future getCaseType() async {
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

      final httpPackageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['CASETYPES']}');

      final httpPackageResponse = await get(httpPackageUrl, headers: headers);

      return httpPackageResponse;
    }
  }

  Future getCase(String caseTypeID, String content) async {
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
        'authorization': basicAuth,
        // 'caseTypeID': caseTypeID,
        // 'content': content
      };
      final httpPackageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['CASES']}?caseTypeID=$caseTypeID&content=$content');

      final httpPackageResponse = await post(httpPackageUrl, headers: headers);

      return httpPackageResponse;
    }
  }
}
