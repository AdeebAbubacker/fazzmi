import 'dart:convert';
import 'dart:developer';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

import '../model/paymentSucsessPage/paymentSuccessPageModel.dart';

class PaymentSuccessPageProvider with ChangeNotifier {
  PayementSuccessPageModel? _paymentSuccesList;
  PayementSuccessPageModel? get paymentSuccesList => _paymentSuccesList;

  bool _paymentLoader = false;
  bool get paymentLoader => _paymentLoader;

  setPaymentLoader(bool val) {
    _paymentLoader = val;
    notifyListeners();
  }

  Future<PayementSuccessPageModel?> getPaymentSuccessDetails(
      {entityId, commigfrom}) async {
    try {
      setPaymentLoader(true);
      var response = await ApiServices()
          .getDataValue("/rest/V1/fazmmi-apis/order/$entityId");
      // print("response:$entityId");
      // log("entity:$entityId");

      // log(entityId);
      // log(response);

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _paymentSuccesList = PayementSuccessPageModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _paymentSuccesList;
    }
    setPaymentLoader(false);
    return _paymentSuccesList;
  }
}
