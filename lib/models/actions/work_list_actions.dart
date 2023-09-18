import 'package:login_flutter/models/services/datapages_services.dart';

class WorkList {
  getWorkList() async {
    return await Datapages().getWorkList().then((value) {
      return value.body;
    });
  }
}
