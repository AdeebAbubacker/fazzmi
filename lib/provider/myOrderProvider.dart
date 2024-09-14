import 'dart:convert';

import 'package:fazzmi/model/myOrderModel/myOrderModel.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class MyOrderProvider with ChangeNotifier {
  MyOrderModel? _myOrderList;
  MyOrderModel? get myOrderList => _myOrderList;

  bool _myOrderloader = true;
  bool get myOrderloader => _myOrderloader;

  setMyOrderLoader(bool val) {
    _myOrderloader = val;
    notifyListeners();
  }

  Future<MyOrderModel?> getMyorderList() async {
    setMyOrderLoader(true);
    var customerid = box.read("customerId");

    try {
      var response = await ApiServices()
          .getDataValue("/rest/V1/order/myorder?customer_id=$customerid");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _myOrderList = MyOrderModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _myOrderList;
    }
    setMyOrderLoader(false);

    return _myOrderList;
  }
}
