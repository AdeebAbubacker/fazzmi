import 'dart:convert';
import 'dart:developer';

import 'package:fazzmi/model/store_category_model/store_category_model.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

import '../model/subcategorymodel/sub_category_model.dart';

class SubCategoryProvider with ChangeNotifier {
  SubCategoryModel? _subCategoryList;
  SubCategoryModel? get subCategoryList => _subCategoryList;
  StoreCategoryModel? _storeCategoryList;
  StoreCategoryModel? get storeCategoryList => _storeCategoryList;

  int _index = 0;
  int get index => _index;

  BuildContext context;
  SubCategoryProvider(this.context);

  get errorMsg => null;
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

  Future<SubCategoryModel?> getSubCategoryList({id}) async {
    setSubCategoryLoader(true);

    try {
       // Reset the store category list before making a new API call
      _storeCategoryList = null;
      var response = await ApiServices()
          .getDataValue("/rest/default/V1/fazmmi-apis/getcategory?id=$id");
log("////////rest/default/V1/fazmmi-apis/getcategory?id=$id");
log("value:$id");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);

        _subCategoryList = SubCategoryModel.fromJson(jsonMap);

        if (_subCategoryList!.data!.mainCategoryList!.isNotEmpty) {
          int catId = int.parse(
              _subCategoryList!.data!.mainCategoryList!.first.categoryId!);

          if (index == 0) {
            // Reset the store category list before making a new API call
            _storeCategoryList = null;
            getStoreList(id: catId);
            print( getStoreList(id: catId));
          }
        }
        setindex(0);

        notifyListeners();
      }
    } catch (e) {
      return _subCategoryList;
    }

    setSubCategoryLoader(false);

    return _subCategoryList;
  }

  Future<StoreCategoryModel?> getStoreList({id}) async {
    setStoreLoader(true);
    var idreturn = id == ""
        ? _subCategoryList!.data!.mainCategoryList!.first.categoryId!
        : id;

    var pincode = box.read("actualpinCode");
    
      log("getStoreList: 00");
    
      log("getStoreList: 01");

    try {
      log("getStoreList: 1");
      var response = await ApiServices().getDataValue(
          "/rest/default/V1/fazmmi-apis/getCategoryStore?category_id=$id&postcode=$pincode");
          log("/rest/default/V1/fazmmi-apis/getCategoryStore?category_id=$id&postcode=$pincode");
      print("getStoreList: Resp");
      print(jsonDecode(response.body) as Map);
      print("/rest/default/V1/fazmmi-apis/getCategoryStore?category_id=$id&postcode=$pincode");
      print("getStoreList: Resp");

      if (response.statusCode == 200) {
        log("getStoreList: 2");
        var jsonMap = jsonDecode(response.body);
    // _storeCategoryList = [] as StoreCategoryModel?;
        _storeCategoryList = StoreCategoryModel.fromJson(jsonMap);
      }
      else if(response.statusCode == 404){
         
      }
      else {
        log("getStoreList: 2.1");
        var jsonMap = jsonDecode("[]");
    // _storeCategoryList = [] as StoreCategoryModel?;
        _storeCategoryList = StoreCategoryModel.fromJson(jsonMap);
      }
      
    } catch (e) {
      log("getStoreList: 3");
      return _storeCategoryList;
    }

    log("getStoreList: 4");
    setStoreLoader(false);

    return _storeCategoryList;
  }
}
