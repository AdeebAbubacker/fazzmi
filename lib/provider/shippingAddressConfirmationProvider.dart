import 'dart:convert';
import 'package:fazzmi/model/addBannerModel/paymentOrderModel/paymentOrderModel.dart';
import 'package:fazzmi/model/shippingAddressConfirmationModel/shippingAddressConfirmationModel.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../model/createOrderModel/createOrdermodel.dart';

class ShipppingAddressConfirmProvider with ChangeNotifier {
  ShippingAddressConfirmationModel? _checkoutCartList;
  BuildContext context;
  ShipppingAddressConfirmProvider(this.context);
  ShippingAddressConfirmationModel? get checkoutCartList => _checkoutCartList;

  List<dynamic>? _addressInformation1;
  List<dynamic>? get addressInformation1 => _addressInformation1;
  List<dynamic>? _addressInformation2;
  List<dynamic>? get addressInformation2 => _addressInformation2;

  /// invoice

  /// create order

  CreateOederModel? _createOrderList;
  CreateOederModel? get createOrderList => _createOrderList;

  /// order id string

  String? _orderIdString;
  String? get orderIdString => _orderIdString;

  /// payement order

  PaymentOrder? _paymentOrderList;
  PaymentOrder? get paymentOrderList => _paymentOrderList;
  bool _loader = true;
  bool get loader => _loader;

  setLoader(bool val) {
    _loader = val;
    notifyListeners();
  }

  Future<ShippingAddressConfirmationModel?> getCheckoutpage(
      {area,
      region,
      regionId,
      regionCode,
      countryId,
      street,
      postCode,
      city,
      firstName,
      lastName,
      telePhone,
      building,
      addresstype = 0}) async {
    setLoader(true);
    var profileInfo = box.read("profileInfo");

    var shippingAddress;
    var billingAddress;

    _addressInformation1 = [
      "$region",
      "$regionId",
      "$regionCode",
      "$countryId",
      "$postCode",
      "$city",
      "$street",
      "$firstName",
      "$lastName",
      "$telePhone",
      "$area",
      "$building",
    ];

    if (addresstype == 0) {
      await box.write("shippingAddress", _addressInformation1);
      await box.write("billingAddress", _addressInformation1);
      shippingAddress = box.read("shippingAddress");
      billingAddress = box.read("billingAddress");
    }
//  "${item.building},${item.street},${item.region},\n"
//                                                 "Pin:${item.postcode}"
    var data = {
      "addressInformation": {
        "shipping_address": {
          "region": "${shippingAddress[0]}",
          "region_id": "550",
          "region_code": "KL",
          "country_id": "${shippingAddress[3]}",
          "street": ["${shippingAddress[6]}"],
          "postcode": "${shippingAddress[4]}",
          "city": "${shippingAddress[5]}",
          "firstname": "${shippingAddress[7]}",
          "lastname": "${shippingAddress[8]}",
          "email": "${profileInfo[0]}",
          "telephone": "${shippingAddress[9]}",
        },
        "billing_address": {
          "region": "${billingAddress[0]}",
          "region_id": "550",
          "region_code": "KL",
          "country_id": "${billingAddress[3]}",
          "street": ["${billingAddress[6]}"],
          "postcode": "${billingAddress[4]}",
          "city": "${billingAddress[5]}",
          "firstname": "${billingAddress[7]}",
          "lastname": "${billingAddress[8]}",
          "email": "${profileInfo[0]}",
          "telephone": "${billingAddress[9]}",
        },
        "shipping_carrier_code": "tablerate",
        "shipping_method_code": "bestway"
      }
    };
    try {
      var response = await ApiServices().postDataWithToken(
          data, "/rest/V1/carts/mine/shipping-information", false);
      // print("data::::::$data");
      // print("Method/URL :${response.request.toString()}");
      // print("Status Code :${response.statusCode.toString()}");
      // print("Body :${response.body.toString()}");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _checkoutCartList = ShippingAddressConfirmationModel.fromJson(jsonMap);
        setLoader(false);
      }
    } catch (e) {
      return _checkoutCartList;
    }

    return _checkoutCartList;
  }

  /// create order

  Future<Object?> createOrder({method}) async {
    setLoader(true);

    var data = {
      "paymentMethod": {"method": "$method"}
    };
    try {
      var response = await ApiServices().postDataWithToken(
          data, "/rest/V1/carts/mine/payment-information", false);
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);

        _orderIdString = jsonMap;

        Provider.of<CartCounterStore>(context, listen: false).loginUsers();

        if (method != "cashondelivery") {
          invoice(orderId: _orderIdString);
        }
      }
    } catch (e) {
      return _orderIdString;
    }
    setLoader(false);

    return _orderIdString;
  }

  /// invoice

  Future<Type> invoice({orderId}) async {
    setLoader(true);

    var data = {"capture": true, "notify": true};
    try {
      var response = await ApiServices().postDataWithAdminToken(
          data, "/rest/V1/order/$orderId/invoice", false);
      print("orderId:::::::$orderId");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        box.write("invoiceId", jsonMap);
        var invoiceId = box.read("invoiceId");
      }
    } catch (e) {
      return String;
    }
    setLoader(false);
    return String;
  }

  /// Razorpay backend api calling

  Future<Type> razorpayApiIntegraion(
      {orderId, razorpaypaymentid, razorpayorderid, razorpaysignature}) async {
    setLoader(true);

    var data = {
      "order_id": orderId,
      "razorpay_payment_id": razorpaypaymentid,
      "razorpay_order_id": razorpayorderid,
      "razorpay_signature": razorpaysignature
    };
    try {
      var response = await ApiServices().postDataWithAdminToken(
          data, "/rest/default/V1/fazmmi-apis/razorpayhistory", false);

      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
      }
    } catch (e) {
      return String;
    }
    setLoader(false);
    return String;
  }

  /// payement order

  Future<PaymentOrder?> getOrderpage() async {
    setLoader(true);
    var token = box.read("token");

    try {
      var response = await ApiServices()
          .getDataValueWith("/rest/V1/fazmmi-apis/order/2", "$token");

      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _paymentOrderList = PaymentOrder.fromJson(jsonMap);
      }
    } catch (e) {
      return _paymentOrderList;
    }
    setLoader(false);

    return _paymentOrderList;
  }
}
