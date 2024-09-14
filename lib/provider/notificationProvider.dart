import 'dart:convert';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import '../model/notificationModel/notificationModel.dart';

class NotificationProvider with ChangeNotifier {
  NotificationModel? _notificationList;
  NotificationModel? get notificationList => _notificationList;

  bool _loader = true;
  bool get loader => _loader;

  setLoader(bool val) {
    _loader = val;
    notifyListeners();
  }

  Future<NotificationModel?> getNotifications() async {
    setLoader(true);

    try {
      var response = await ApiServices()
          .getDataValue("/rest/V1/fazmmi-apis/getNotifications");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);

        _notificationList = NotificationModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _notificationList;
    }
    setLoader(false);

    return _notificationList;
  }
}
