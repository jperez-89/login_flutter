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

  Future createCase(String caseTypeID) async {
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

      final httpPackcageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['CASES']}');

      final Map<String, String> headersData = {
        'content-type': 'text/plain',
        'authorization': basicAuth
      };

      final String bodyData = '{"caseTypeID": "$caseTypeID", "content": "" }';

      final httpPackageResponse = await post(
        httpPackcageUrl,
        headers: headersData,
        body: bodyData,
      );

      // final httpPackcageUrl = Uri.parse(
      //     '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['CASES']}?caseTypeID=$caseTypeID&content=""');

      // final Map<String, String> headersData = {
      //   'content-type': 'application/json',
      //   // 'X-Requested-With': 'XMLHttpRequest',
      //   // 'content-type': 'application/x-www-form-urlencoded',
      //   // 'content-type': 'text/plain',
      //   'accept': '*/*',
      //   'authorization': basicAuth
      // };

      // final httpPackageResponse =
      //     await post(httpPackcageUrl, headers: headersData);

      // print(httpPackageResponse.statusCode);
      // print(httpPackageResponse.body);

      return httpPackageResponse;
    }
  }

  Future getCase(String caseID) async {
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
        'accept': '*/*',
        'Authorization': basicAuth
      };

      final httpPackageUrl = Uri.parse(
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['CASES']}/$caseID');

      final httpPackageResponse = await get(httpPackageUrl, headers: headers);

      return httpPackageResponse;
    }
  }
}
