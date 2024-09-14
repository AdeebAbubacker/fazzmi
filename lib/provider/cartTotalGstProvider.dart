import 'dart:convert';
import 'package:fazzmi/model/grandTotalGstModel/grandTotalGstModel.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class CartTotalGstProvider with ChangeNotifier {
  GrandTotalGstModel? _cartTotalGstList;
  GrandTotalGstModel? get cartTotalGstList => _cartTotalGstList;
  GrandTotalGstModel? _guestTotalGstList;
  GrandTotalGstModel? get guestTotalGstList => _guestTotalGstList;

  bool _cartTotalGstloader = true;
  bool get cartTotalGstloader => _cartTotalGstloader;

  setcartTotalGstloader(bool val) {
    _cartTotalGstloader = val;
    notifyListeners();
  }

  Future<GrandTotalGstModel?> getCartTotalGstList() async {
    var token = box.read("token");

    try {
      setcartTotalGstloader(true);
      var response = await ApiServices()
          .getDataValueWith("/rest/V1/carts/mine/totals", "$token");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _cartTotalGstList = GrandTotalGstModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _cartTotalGstList;
    }
    setcartTotalGstloader(false);

    return _cartTotalGstList;
  }

  Future<GrandTotalGstModel?> getGuestTotalGstList() async {
    var guestQuoteId = box.read("quoteIdGuest");
    try {
      setcartTotalGstloader(true);
      var response = await ApiServices()
          .getDataValue("/rest/V1/guest-carts/$guestQuoteId/totals");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _guestTotalGstList = GrandTotalGstModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _guestTotalGstList;
    }
    setcartTotalGstloader(false);
    return _guestTotalGstList;
  }
}
