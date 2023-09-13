import 'package:login_flutter/models/services/case_service.dart';

class CaseActions {
  getCaseType() async {
    return await CaseService().getCaseType().then((value) {
      return value.body;
    });
  }
}
