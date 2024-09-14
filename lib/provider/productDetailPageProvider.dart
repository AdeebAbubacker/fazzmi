import 'dart:convert';
import 'package:fazzmi/model/productDetailModel/productDetailModel.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import '../model/productCustomizeModel/productCustomizeModel.dart';

class ProductDetailPageProvider with ChangeNotifier {
  ProductDetailModel? _productDetailList;
  ProductDetailModel? get productDetailList => _productDetailList;
  ProductCustomize? _productCustomizeDetailList;
  ProductCustomize? get productCustomizeDetailList =>
      _productCustomizeDetailList;
  bool _loader = true;
  bool get loader => _loader;
  bool _loader2 = true;
  bool get loader2 => _loader2;
  setLoader2(bool val) {
    _loader2 = val;
    notifyListeners();
  }

  setLoader(bool val) {
    _loader = val;
    notifyListeners();
  }

  int _currentindex = 0;
  int get currentindex => _currentindex;

  void changeIndex({value}) {
    _currentindex = value;
    notifyListeners();
  }

  int _currentindex2 = 0;
  int get currentindex2 => _currentindex2;

  void changeIndex2({value}) {
    _currentindex2 = value;
    notifyListeners();
  }

  Future<ProductDetailModel?> getProductDetails(String sku) async {
    try {
      setLoader(true);
      var response = await ApiServices().getDataValue("/rest/V1/products/$sku");

      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _productDetailList = ProductDetailModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _productDetailList;
    }
    setLoader(false);

    return _productDetailList;
  }

  Future<ProductCustomize?> getProductCustomizeDetails(String sku) async {
    try {
      setLoader2(true);
      var response = await ApiServices()
          .getDataValue("/rest/V1/fazmmi-apis/getProduct/$sku");
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _productCustomizeDetailList = ProductCustomize.fromJson(jsonMap);
      }
    } catch (e) {
      return _productCustomizeDetailList;
    }
    var data = _productCustomizeDetailList!.data![0].childSku!;
    setLoader2(false);
    getProductDetails(data);

    return _productCustomizeDetailList;
  }
}
