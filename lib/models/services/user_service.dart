// import 'dart:async';
import 'dart:convert';
import 'package:login_flutter/models/services/endpoints.dart';
import 'package:login_flutter/models/services/service.dart';

class UserService {
  /// Inicia la sesion con los datos correpondientes de pega
  /// Params
  /// @username
  /// @password
  Future login(String username, String password) async {
    String user = username;
    String pass = password;

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
          '${endpoints['PEGAURL'] + endpoints['VERSION'] + endpoints['AUTHENTICATE']}');

      final httpPackageResponse = await get(httpPackageUrl, headers: headers);

      return httpPackageResponse;
    }
  }
}
