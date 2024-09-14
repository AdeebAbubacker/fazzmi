import 'dart:convert';

import 'package:fazzmi/model/addressModel/addressModel.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/material.dart';

class AddressProvider with ChangeNotifier {
  bool _isLoading = false;
  List<AddressData>? _addressList;

  bool get activeStatus => _isLoading;
  List<AddressData>? get addressList => _addressList;
  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //add or edit
  /*
  |
  |addUpdateAddress() ----- You can use for both add and update address !
  |
  */

  Future<Object> addUpdateAddress({
    data,
    addrPageType,
    addId,
  }) async {
    var url = (addrPageType == "New")
        ? "/rest/V1/customer/address/"
        : "/rest/V1/customer/address/$addId";

    var response;

    if (addrPageType == "New") {
      response = await ApiServices().postDataWithToken(data, url, false);
    } else if (addrPageType == "Modify") {
      response = await ApiServices().putData(data, url, false);
    }
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      fetchAddresList();
      return "Success";
    } else {
      return body['message'];
    }
  }

  //
  //Fetch
  //
  Future<List<AddressData>?> fetchAddresList() async {
    setIsLoading(true);
    try {
      var customerId = box.read("customerId") ?? 0;
      var response = await ApiServices()
          .getDataValue("/rest/V1/customer/address/$customerId");
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        var list = jsonMap['data'] as List;
        _addressList = list.map((p) => AddressData.fromJson(p)).toList();
        setIsLoading(false);
        return _addressList;
      }
    } catch (e) {
      setIsLoading(false);
      return null;
    }
  }

  //delete
  Future<Object> deleteAddress({addressId}) async {
    var response = await ApiServices()
        .deleteData("", "/rest/V1/customer/address/$addressId", false);
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      fetchAddresList();
      return "Success";
    } else {
      return body['message'];
    }
  }
}
