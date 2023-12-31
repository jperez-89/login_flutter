import 'dart:convert';
import 'package:login_flutter/models/services/case_service.dart';

class CaseActions {
  getCaseType() async {
    return await CaseService().getCaseType().then((value) {
      return value;
    });
  }

  createCase(String caseTypeID) async {
    return await CaseService().createCase(caseTypeID).then((value) {
      if (value.statusCode == 201) {
        Map<String, dynamic> json = jsonDecode(value.body);

        return json;
      }
    });
  }

  refreshCase(String caseID) async {
    return await CaseService().getCase(caseID).then((value) {
      return value;
    });
  }
}
