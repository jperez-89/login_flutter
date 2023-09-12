import 'dart:convert';
import 'package:http/http.dart' as http;

class PegaConection {
  Future conexion(String url, String user, String pass) async {
    // String username = 'InterpreterOP';
    // String password = 'hyopJK77@';
    String username = user;
    String password = pass;

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final httpPackageUrl = Uri.parse(url);

    final Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': basicAuth
    };

    final httpPackageResponse =
        await http.get(httpPackageUrl, headers: headers);

    // print('Response status: ${httpPackageResponse.statusCode}');
    // print('Response body: ${httpPackageResponse.body}');
    return httpPackageResponse;
    // }
  }
}
