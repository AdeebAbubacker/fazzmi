import 'dart:convert';
import 'package:fazzmi/model/addBannerModel/addBannerModel.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class AddBannerProvider with ChangeNotifier {
  AddBannerModel? _addBannerList;
  AddBannerModel? get addBannerList => _addBannerList;

  bool _addBanerloader = true;
  bool get addBanerloader => _addBanerloader;

  setaddBanerloader(bool val) {
    _addBanerloader = val;
    notifyListeners();
  }

  Future<AddBannerModel?> getAddBannerDetails(type) async {
    try {
      setaddBanerloader(true);
      var response = await ApiServices()
          .getDataValue("/rest/V1/fazmmi-apis/homeabanner?type=$type");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _addBannerList = AddBannerModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _addBannerList;
    }
    setaddBanerloader(false);

    return _addBannerList;
  }
}
