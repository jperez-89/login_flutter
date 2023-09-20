import 'dart:convert';

import 'package:login_flutter/models/services/case_service.dart';

class CaseActions {
  getCaseType() async {
    return await CaseService().getCaseType().then((value) {
      return value.body;
    });
  }

  getNextAssignmentID(String caseTypeID, String content) async {
    return await CaseService().getCase(caseTypeID, content).then((value) {
      return jsonDecode(value.body)["nextAssignmentID"];
    });
  }

  getCaseID(String nextAssignmentID) {
    //ASSIGN-WORKLIST CF-FW-INTERPRE-WORK I-13008!INTREPRETEPROCESS  ---> I-13008
    return nextAssignmentID.substring(
        nextAssignmentID.lastIndexOf(" "), nextAssignmentID.indexOf("!"));
  }
}
