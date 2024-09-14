import 'dart:convert';
import 'package:fazzmi/model/homepage_category/homepage_category_model.dart';
import 'package:fazzmi/model/profileDataModel/profileDataModel.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class HomepageCategoryProvider with ChangeNotifier {
  HomepageCategoryModel? _categoryList;
  HomepageCategoryModel? get categoryList => _categoryList;
  ProfileDataModel? _profileDataList;
  ProfileDataModel? get profileDataList => _profileDataList;
  bool _loader = true;
  bool get loader => _loader;

  setLoader(bool val) {
    _loader = val;
    notifyListeners();
  }

  Future<HomepageCategoryModel?> getCategory() async {
    setLoader(true);

    try {
      var response = await ApiServices()
          .getDataValue("/rest/default/V1/fazmmi-apis/homecategory");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _categoryList = HomepageCategoryModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _categoryList;
    }
    setLoader(false);

    return _categoryList;
  }
}
