import 'package:login_flutter/models/services/case_service.dart';

class CaseActions {
  getCaseType() {
    return CaseService().getCaseType().then((value) {
      return value.body;
    });
  }
}
