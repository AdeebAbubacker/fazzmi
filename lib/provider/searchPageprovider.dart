import 'dart:convert';

import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/material.dart';

import '../model/searchModel/searchModel.dart';

class SearchPageProvider with ChangeNotifier {
  bool _loader = false;
  bool get loader => _loader;

  SerarchServiceModel? _searchItem;
  SerarchServiceModel? get searchItem => _searchItem;

  setLoader(bool val) {
    _loader = val;
    notifyListeners();
  }

  Future<SerarchServiceModel?> getSearchData({searchText = ''}) async {
    setLoader(true);
    if (searchText == '') {
      setLoader(false);
      return _searchItem = null;
    }
    try {
      var response = await ApiServices()
          .getDataValue("/rest/V1/fazmmi-apis/search/$searchText");

      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);
        // var data = jsonMap['Data'];
        try {
          _searchItem = SerarchServiceModel.fromJson(jsonMap);
         
        } catch (e) {}
      }
    } catch (e) {
      return _searchItem;
    }
    setLoader(false);

    return _searchItem;
  }
}
