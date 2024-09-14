import 'dart:convert';
import 'package:fazzmi/core/constants/boxvariables.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import '../model/deals_shop_by_category_model/deals_shopbycategory_model.dart';
import '../model/dealsproductcategorymodel/deals_product_deals_model.dart';

class DealsProvider extends ChangeNotifier {
  /// deals shopByCategory
  DealsShopBycategoryModel? _dealsCategory;
  DealsShopBycategoryModel? get dealsCategory => _dealsCategory;
// deals stores
  DealsStoreCategoryModel? _dealsStore;
  DealsStoreCategoryModel? get dealsStore => _dealsStore;

  bool _dealsCategoryLoader = true;
  bool get dealsCategoryLoader => _dealsCategoryLoader;
  bool _dealsStoreLoader = true;
  bool get dealsStoreLoader => _dealsStoreLoader;
  int _index = 0;
  int get index => _index;

  setDealsCategoryLoader(value) {
    _dealsCategoryLoader = value;
    notifyListeners();
  }

  setDealsStoreLoader(value) {
    _dealsStoreLoader = value;
    notifyListeners();
  }

  setindex(value) {
    _index = value;
    notifyListeners();
  }

  // deals category section function

  Future<DealsShopBycategoryModel?> getDealsShopCategorySection() async {
    setDealsCategoryLoader(true);

    var response = await ApiServices()
        .getDataValue("/rest/default/V1/fazmmi-apis/getcategory?id=15");
    if (response.statusCode == 200) {      var jsonMap = jsonDecode(response.body);
      _dealsCategory = DealsShopBycategoryModel.fromJson(jsonMap);

      if (_dealsCategory!.data!.mainCategoryList!.isNotEmpty) {
        int catId =
            int.parse(_dealsCategory!.data!.mainCategoryList![0].categoryId!);

        if (index == 0) {
          await getDealsStore(id: catId);
          await setindex(0);
        }
      }

      setDealsCategoryLoader(false);
    }

    return _dealsCategory;
  }

  // deals store list function

  Future<DealsStoreCategoryModel?> getDealsStore({id}) async {
    setDealsStoreLoader(true);
    var response = await ApiServices().getDataValue(
        "/rest/default/V1/fazmmi-apis/getDealsStores?postcode=$selectedpincode&sub_cat_id=$id");

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      _dealsStore = DealsStoreCategoryModel.fromJson(jsonMap);
      setDealsStoreLoader(false);
    }
    return _dealsStore;
  }
}
