import 'dart:convert';

import 'package:fazzmi/model/store_category_model/store_category_model.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

import '../model/storesubcategorymodel/store_subcategory_model.dart';

class StoreSubCategoryProvider with ChangeNotifier {
  String? _errorMsg;
  String? get errorMsg => _errorMsg;
  set errorMsg(String? value) {
    _errorMsg = value;
    notifyListeners();
  }

  StoreSubCategoryModel? _storesubCategoryList;
  StoreSubCategoryModel? get storesubCategoryList => _storesubCategoryList;
  StoreCategoryModel? _storeCategoryList;
  StoreCategoryModel? get storeCategoryList => _storeCategoryList;

  int _index = 0;
  int get index => _index;
  setindex(value) {
    _index = value;
    notifyListeners();
  }

  bool _subcategoryloader = true;
  bool get subcategoryloader => _subcategoryloader;
  setSubCategoryLoader(bool val) {
    _subcategoryloader = val;
    notifyListeners();
  }

  bool _storeloader = true;
  bool get storeloader => _storeloader;

  setStoreLoader(bool val) {
    _storeloader = val;
    notifyListeners();
  }

  Future<StoreSubCategoryModel?> getSubCategoryList({id}) async {
    setSubCategoryLoader(true);

    try {
      var response = await ApiServices()
          .getDataValue("/rest/default/V1/fazmmi-apis/getStore?store_id=$id");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _storesubCategoryList = StoreSubCategoryModel.fromJson(jsonMap);

        if (_storesubCategoryList!.data!.storeCategory!.isNotEmpty) {
          int catId = int.parse(
              _storesubCategoryList!.data!.storeCategory!.first.categoryId!);
          if (index == 0) {
            getStoreList(id: catId);
          }
        }

        notifyListeners();
      }
    } catch (e) {
      return _storesubCategoryList;
    }

    setSubCategoryLoader(false);

    return _storesubCategoryList;
  }

  Future<StoreCategoryModel?> getStoreList({id}) async {
    setStoreLoader(true);
    var idreturn = id == ""
        ? _storesubCategoryList!.data!.storeCategory!.first.categoryId!
        : id;

    var pincode = box.read("actualpinCode");

    try {
      var response = await ApiServices().getDataValue(
          "/rest/default/V1/fazmmi-apis/getCategoryStore?category_id=$idreturn&postcode=$pincode");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _storeCategoryList = StoreCategoryModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _storeCategoryList;
    }
    setStoreLoader(false);

    return _storeCategoryList;
  }
}
