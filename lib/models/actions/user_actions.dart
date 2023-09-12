import 'package:login_flutter/models/services/user_service.dart';

class UserActions {
  login(String username, String password) {
    final String user = username;
    final String pass = password;

    return UserService().login(user, pass).then((value) {
      return value;
    });
  }
}
