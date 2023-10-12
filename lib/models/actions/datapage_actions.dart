import 'package:login_flutter/models/services/datapages_services.dart';

class DataPageActions {
  getDataPage(String dataPages) async {
    return await DataPagesServices().getDataPage(dataPages).then((value) {
      return value;
    });
  }
}
