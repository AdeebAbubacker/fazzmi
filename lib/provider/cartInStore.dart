import 'dart:async';
import 'dart:convert';
import 'dart:developer';

// import 'package:fazzmi/core/constans/constants.dart';
import 'package:fazzmi/model/cart_response_model/cart_response_model.dart';
import 'package:fazzmi/model/cartproductlist/cart_product_list.dart'
    as login_cart;
import 'package:fazzmi/model/grandTotalGstModel/grandTotalGstModel.dart';
import 'package:fazzmi/model/profileDataModel/profileDataModel.dart';
import 'package:fazzmi/model/wishlist/wishlist_model.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../model/Delivery_feeModel/delivery_fee_model.dart';
import '../model/GuestCartResponsemodell/guestCart_response_model.dart';
import '../model/cartproductlist/cart_product_list.dart';
import '../model/featuredProductModel/featuredProductModel.dart';
import '../model/guestAddUpdateModel/guestAddUpdateCart.dart';
import '../model/storesubcategorymodel/store_subcategory_model.dart';

class CartCounterStore with ChangeNotifier {
  List<dynamic>? _profileInformation;
  List<dynamic>? get profileInformation => _profileInformation;

  bool _addtoCartLoader = false;

  bool get addtoCartLoader => _addtoCartLoader;
  setAddtoCartLoader(bool val) {
    _addtoCartLoader = val;

    notifyListeners();
  }

  int _index = 0;
  int get index => _index;
  setindex(value) {
    _index = value;
    notifyListeners();
  }

  bool _commoLoader = false;
  bool get commoLoader => _commoLoader;

  int? _cartIndex;
  int? get cartIndex => _cartIndex;
  int? _favIndex = 456;
  int? get favIndex => _favIndex;

  setCommonLoader(bool val) {
    _commoLoader = val;
    notifyListeners();
  }

  setCartIndex(int? index) {
    _cartIndex = index;
    notifyListeners();
  }

  setFavoriteIndex(int? index) {
    _favIndex = index;
    notifyListeners();
  }

  //// STORE SUB CATEGORY PAGE
  // StoreSubCategoryModel? _storesubCategoryList;
  // StoreSubCategoryModel? get storesubCategoryList => _storesubCategoryList;

  // List<StoreCategory> _storeCategoryList = [];
  // List<StoreCategory> get storeCategoryList => _storeCategoryList;

  // bool _subcategoryloader = true;
  // bool get subcategoryloader => _subcategoryloader;

  // setSubCategoryLoader(bool val) {
  //   _subcategoryloader = val;
  //   notifyListeners();
  // }

  /// Featured product list
  /* ---------initialize product list model------*/
  List<FeaturedProductItem> _featuredProductList = [];
  List<FeaturedProductItem> get featuredProductList => _featuredProductList;

  int _currentCatId = 0;
  int get currentCatId => _currentCatId;

  Future<void> clearProductList() async {
    _featuredProductList = [];
    _currentCatId = 0;
    notifyListeners();
  }

  Future<List<FeaturedProductItem>?> fetchFeaturedProduct(
      {loadVar, categoryId, storeId, page}) async {
    setLoadState(loadVar, true);

    int catIdInteger = int.parse(categoryId as String);

    if (catIdInteger != currentCatId) {
      clearProductList();
    }

    _currentCatId = catIdInteger;

    var result = await ApiServices().getFeaturedProduct(
        categoryId: categoryId, storeId: storeId, page: page);

    _featuredProductList.addAll(result.data);
    // var featuredProductData = result.data;

    //   if (!featuredProductData) {
    //     page - 1;
    //   } else {
    //     _featuredProductList.addAll(featuredProductData);
    //   }
    setLoadState(loadVar, false);

    return _featuredProductList;
  }

  // Future<List<StoreCategory>?> getSubCategoryList(
  //     {id, parentCategoryId, index}) async {
  //   _storeCategoryList.clear();
  //   notifyListeners();
  //   setSubCategoryLoader(true);

  //   try {
  //     var response = await ApiServices().getDataValue(
  //         "/rest/V1/fazmmi-apis/getStore?store_id=$id&category_id=$parentCategoryId");

  //     if (response.statusCode == 200) {
  //       var jsonMap = jsonDecode(response.body);

  //       final data = jsonMap['data']['store_category'] as List;

  //       _storeCategoryList =
  //           data.map((e) => StoreCategory.fromJson(e)).toList();

  //       if (_storeCategoryList.isNotEmpty) {
  //         int catId = int.parse(_storeCategoryList[index].categoryId!);

  //         if (index == _index) {
  //           fetchFeaturedProduct(
  //               categoryId: catId, page: 1, storeId: id, loadVar: "_isLoading");
  //         }
  //       }

  //       // notifyListeners();
  //     }
  //     setSubCategoryLoader(false);
  //   } catch (e) {
  //     return _storeCategoryList;
  //   }

  //   return _storeCategoryList;
  // }

  ////// favorite change
  fetchFavourite({loadVar}) async {
    setLoadState(loadVar, true);
    await loadFavourite();
    setLoadState(loadVar, false);
  }

  initialState() {
    guestQuiteId = box.read("quoteIdGuest");
    quoteId = box.read("quoteIdLogin");
    notifyListeners();
  }

  loadFavourite() async {
    _wishlist = await getWishList();
    notifyListeners();
  }

  bool _isLoadMore = false,
      _isLoading = false,
      _isCartLoad = false,
      isStoreSubCategoryLoader = false;
  bool get isLoadMore => _isLoadMore;
  bool get isLoad => _isLoading;
  bool get isCartLoad => _isCartLoad;
  bool get isStoreCategoryLoad => isStoreSubCategoryLoader;

  setLoadState(String variable, bool value) {
    switch (variable) {
      case '_isLoading':
        {
          _isLoading = value;
        }
        break;
      case '_isStoreSubCategoryLoader':
        {
          isStoreSubCategoryLoader = value;
        }
        break;
      case '_isLoadMore':
        {
          _isLoadMore = value;
        }
        break;
      case '_isCartLoad':
        {
          _isCartLoad = value;
        }
        break;
      default:
        break;
    }
    notifyListeners();
  }

  var guestQuiteId, quoteId;
  checkIsFavourite({sku}) {
    var isFavourite;
    if (quoteId != null || guestQuiteId == null) {
      isFavourite = _wishlist!.data!.where((ele) => ele.sku == sku);
      return isFavourite;
    } else {
      return;
    }
  }

  changeFavourite({isAddFav, productid}) {
    var response;
    bool retRes = false;
    setLoadState('_isCartLoad', true);
    if (isAddFav) {
      addfavorite(productId: productid);
      retRes = true;
    } else {
      deletefavorite(productId: productid);
      retRes = true;
    }
    loadFavourite();

    Future.delayed(const Duration(milliseconds: 500), () {
      setLoadState('_isCartLoad', false);
    });
    return retRes;
  }

  ////*  end favorite

  /// Cart storing

  ViewCartPageModel? _productDetailList;
  ViewCartPageModel? get productDetailList => _productDetailList;
  CartResponseModel? _cartResponseModel;
  CartResponseModel? get cartResponseModel => _cartResponseModel;

  /// gst
  GrandTotalGstModel? _cartTotalGstList;
  GrandTotalGstModel? get cartTotalGstList => _cartTotalGstList;
  GrandTotalGstModel? _guestTotalGstList;
  GrandTotalGstModel? get guestTotalGstList => _guestTotalGstList;

  /// store product list

  ViewWishListModel? _wishlist;
  ViewWishListModel? get wishlist => _wishlist;
  GuestCartResponsemodel? _guestCartList;
  GuestCartResponsemodel? get guestCartList => _guestCartList;
  GuestAddUpdateCartModel? _guestCartAddUpdateList;
  GuestAddUpdateCartModel? get guestCartAddUpdateList =>
      _guestCartAddUpdateList;
  ProfileDataModel? _profileDataList;
  ProfileDataModel? get profileDataList => _profileDataList;

  double count = 0.0;
  var box = GetStorage();

  void saveToken({token}) async {
    box.write("token", token);
    notifyListeners();
    await getProfileData(token: token);
  }

  /// MERGE GUEST USERS

  Future<Object?> mergeguest({customerId}) async {
    var quoteId = box.read("quoteIdGuest");

    var _totalCartCount = 0;

    var data = {"customerId": customerId, "storeId": 1};

    var response = await ApiServices()
        .putDataWithToken(data, "/rest/V1/guest-carts/$quoteId", false);

    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      box.remove("quoteIdGuest");
      await loginUsers();

      await getCartProductDetailsLogin();

      notifyListeners();

      return "Success";
    } else {
      return body['message'];
    }
  }

  void incrementCount(bool val, {loadVar}) {
    count = count + 0.1;
    notifyListeners();
    setLoadState(loadVar, true);
    _loader = val;
  }

  void removetoken() {
    box.remove("token");
    box.remove("quoteIdLogin");

    notifyListeners();
  }

  void decrementCount() {
    if (count > 0.0) {
      count = count - 0.1;
      notifyListeners();
    }
  }

  bool expanded = false;

  setCartCount(int count) {
    _cartCount += 1;
    notifyListeners();
  }

  bool _loader = true;
  bool get loader => _loader;

  setLoader(bool val) {
    _loader = val;
    notifyListeners();
  }

  bool _loader10 = true;
  bool get loader10 => _loader10;

  setLoader10(bool val) {
    _loader10 = val;
    notifyListeners();
  }

  bool _loader2 = true;
  bool get loader2 => _loader2;

  setLoader2(bool val) {
    _loader2 = val;
    notifyListeners();
  }

  bool _loader4 = true;
  bool get loader4 => _loader4;

  setLoader4(bool val) {
    _loader4 = val;
    notifyListeners();
  }

  bool _storeCategoryloader = true;
  bool get storeCategoryloader => _storeCategoryloader;

  setstoreCategoryloader(bool val) {
    _storeCategoryloader = val;
    notifyListeners();
  }

  bool _loader3 = true;
  bool get loader3 => _loader3;

  setLoader3(bool val) {
    _loader3 = val;
    notifyListeners();
  }

  int _cartCount = 0;
  int get cartCount => _cartCount;

  changeCartTotalCount(val) {
    _cartCount = val;

    notifyListeners();
  }

  double _totalPrice = 0;
  double get totalPrice => _totalPrice;
  double _storeminimumvalue = 200.00;
  double get storeminimumvalue => _storeminimumvalue;
  double _leneraprogresIndicatorValue = 0.0;
  double get leneraprogresIndicatorValue => _leneraprogresIndicatorValue;
  double _morePrice = 100.00;
  int totalcount = 0;
  double get morePrice => _morePrice;
  void moreVAlue() {
    _morePrice =
        double.parse((_storeminimumvalue - _totalPrice).toStringAsFixed(2));

    _leneraprogresIndicatorValue = _totalPrice / _storeminimumvalue;
  }

  void totalPriceValue(ViewCartPageModel price) {
    var length = price.items!.length;
    _totalPrice = 0;
    for (var item in price.items!) {
      _totalPrice +=
          (double.parse(item.extensionAttributes!.price!.toString()) *
              item.qty!);
    }
    notifyListeners();
  }

  void totalPriceValue2(GuestCartResponsemodel price) {
    var length = price.items!.length;
    _totalPrice = 0;
    for (var item in price.items!) {
      _totalPrice +=
          (double.parse(item.extensionAttributes!.price!.toString()) *
              item.qty!);
    }
    notifyListeners();
  }

  /// ADD FAVORITE

  Future<Object?> addfavorite({productId, favIndex}) async {
    setFavoriteIndex(favIndex);

    var customerId = box.read("customerId");

    var data = {"customer_id": customerId, "product_id": productId};

    try {
      setLoader10(false);
      var response =
          await ApiServices().postData(data, "/rest/V1/wishlist/add", false);

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _wishlist = ViewWishListModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _wishlist; // _wishlist!.data![0].wishlistItemId!;
    }

    getWishList();
    setFavoriteIndex(433);
    setLoader10(true);

    return _wishlist;
    //_wishlist!.data![0].wishlistItemId!;
  }

  /// DELETE WISHLIST

  Future<Object> deletefavorite({productId, favIndex}) async {
    setFavoriteIndex(favIndex);

    var customerId = box.read("customerId");
    var data = {"customer_id": customerId, "wishlist_item_id": productId};
    setLoader10(false);

    var response =
        await ApiServices().postData(data, "/rest/V1/wishlist/delete", false);

    var body = json.decode(response.body);
    notifyListeners();
    await getWishList();
    if (response.statusCode == 200) {
      notifyListeners();
      setFavoriteIndex(400);
      setLoader10(true);

      return "Success";
    } else {
      return body['message'];
    }
  }

  //GET WISHLIST

  Future<ViewWishListModel?> getWishList() async {
    var id = box.read("customerId");

    try {
      setLoader4(true);
      var response = await ApiServices()
          .getDataValueWith("/rest/V1/wishlist/items/$id", token);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _wishlist = ViewWishListModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _wishlist;
    }
    setLoader4(false);

    return _wishlist;
  }

  /// Addto cart

  Future<bool> addtoCart(
      {index,
      profuctfromDetailPage = false,
      primaryqty = 4,
      qty,
      name,
      productid,
      productType = "simple",
      colorId = 0,
      sizeId = 0,
      colorOprionId = 0,
      sizeOptionId = 0}) async {
    // setAddtoCartLoader(true);
    setCartIndex(index);

    // setLoader(true);

    if (box.read("quoteIdLogin") != null) {
      if (profuctfromDetailPage) {
        if (primaryqty == 0) {
          await addProductCartLogin(
              primaryqty: primaryqty,
              sizeOptionId: sizeOptionId,
              colorOprionId: colorOprionId,
              qty: qty,
              sku: name,
              colorId: colorId,
              productType: productType,
              sizeId: sizeId);
        } else {
          await updateProductCartLogin(
              colorOprionId: colorOprionId,
              primaryqty: primaryqty,
              sizeOptionId: sizeOptionId,
              qty: qty,
              sku: name,
              productid: productid,
              colorId: colorId,
              productType: productType,
              sizeId: sizeId);
        }
      } else {
        if (qty > 0) {
          await updateProductCartLogin(
              colorOprionId: colorOprionId,
              primaryqty: primaryqty,
              sizeOptionId: sizeOptionId,
              qty: qty + 1,
              sku: name,
              productid: productid,
              colorId: colorId,
              productType: productType,
              sizeId: sizeId);
        } else if (qty == 0) {
          await addProductCartLogin(
              primaryqty: primaryqty,
              sizeOptionId: sizeOptionId,
              colorOprionId: colorOprionId,
              qty: qty + 1,
              sku: name,
              colorId: colorId,
              productType: productType,
              sizeId: sizeId);
        }
      }
    } else {
      if (profuctfromDetailPage) {
        if (primaryqty == 0) {
          await addProductCartGuest(
            colorOprionId: colorOprionId,
            primaryqty: primaryqty,
            sizeOptionId: sizeOptionId,
            colorId: colorId,
            productType: productType,
            sizeId: sizeId,
            qty: qty,
            sku: name,
          );
        } else {
          await updateProductCartGuest(
            colorOprionId: colorOprionId,
            primaryqty: primaryqty,
            sizeOptionId: sizeOptionId,
            colorId: colorId,
            productType: productType,
            sizeId: sizeId,
            qty: qty,
            sku: name,
            productid: productid,
          );
        }
      } else {
        if (qty > 0) {
          await updateProductCartGuest(
            colorOprionId: colorOprionId,
            primaryqty: primaryqty,
            sizeOptionId: sizeOptionId,
            colorId: colorId,
            productType: productType,
            sizeId: sizeId,
            qty: qty + 1,
            sku: name,
            productid: productid,
          );
        } else if (qty == 0) {
          await addProductCartGuest(
            colorOprionId: colorOprionId,
            primaryqty: primaryqty,
            sizeOptionId: sizeOptionId,
            colorId: colorId,
            productType: productType,
            sizeId: sizeId,
            qty: qty + 1,
            sku: name,
          );
        }
      }
    }

    // setLoader(false);

    // setCommonLoader(false);
    return true;
  }

  /// DECREMENT CART FUNCTION

  decrementCart({index, qty, productid, name}) {
    setCartIndex(index);
    // setCommonLoader(true);
    setLoader(true);

    if (box.read("quoteIdLogin") != null) {
      if (qty > 1) {
        updateProductCartLogin(qty: qty - 1, sku: name, productid: productid);
      } else if (qty == 1) {
        deleteLoginProduct(productid: productid);
      }
    } else if (box.read("quoteIdGuest") != null) {
      if (qty > 1) {
        updateProductCartGuest(qty: qty - 1, sku: name, productid: productid);
      } else if (qty == 1) {
        deleteguestProduct(productid: productid);
      }
    }
    setLoader(false);
    // setCommonLoader(false);
  }

  /// GET FEATURES PRODUCTS
  StoreSubCategoryModel? _storeProductlist;
  StoreSubCategoryModel? get storeProductlist => _storeProductlist;

  /// clear storeproduct list
  // clearStoreProductList() {
  //   _storeProductlist = null;
  //   notifyListeners();
  // }

  Future<StoreSubCategoryModel?> getStoreProductDeatils({storeId}) async {
    try {
      setstoreCategoryloader(true);
      var response = await ApiServices().getDataValue(
          "/rest/default/V1/fazmmi-apis/getStore?store_id=$storeId");

      log("storeId:::::$storeId");
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _storeProductlist = StoreSubCategoryModel.fromJson(jsonMap);
        log("JSON sss: ${jsonEncode(jsonMap)}");
        setstoreCategoryloader(false);
        _morePrice = double.parse(_storeProductlist!.data!.minOrderAmount!);
        _storeminimumvalue =
            double.parse(_storeProductlist!.data!.minOrderAmount!);
        notifyListeners();
      }
    } catch (e) {
      return _storeProductlist;
    }

    return _storeProductlist;
  }

  ///  LOGIN

  Future<Object> loginUsers() async {
    var token = box.read("token");

    var response =
        await ApiServices().postDataWithToken("", "/rest/V1/carts/mine", false);

    var body = json.decode(response.body);

    box.write("quoteIdLogin", body);

    var quoteIdLogin = box.read("quoteIdLogin");

    notifyListeners();
    if (response.statusCode == 200) {
      notifyListeners();
      return "Success";
    } else {
      return body['message'];
    }
  }

  /// login cart products

  Future<ViewCartPageModel?> getCartProductDetailsLogin() async {
    var token = box.read("token");

    try {
      setLoader(true);
      var response =
          await ApiServices().getDataValueWith("/rest/V1/carts/mine", token);
      print(token);

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _productDetailList = ViewCartPageModel.fromJson(jsonMap);

        await cartPageGetGstDeliveryamount(type: "login");
      }
      if (response.statusCode == 400) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        return jsonMap["message"];
      }
    } catch (e) {
      return _productDetailList;
    }
    setLoader(false);
    totalPriceValue(_productDetailList!);
    moreVAlue();
    _cartCount = int.parse("${_productDetailList?.itemsQty}");
    changeCartTotalCount(_cartCount);

    return _productDetailList;
  }

  Future<dynamic> cartPageGetGstDeliveryamount({type}) async {
    var data = {
      "addressInformation": {
        "shipping_address": {"country_id": "IN", "postcode": 682301},
        "shipping_carrier_code": "flatrate",
        "shipping_method_code": "flatrate"
      }
    };
    var guestQuoteId = box.read("quoteIdGuest");


    // try {
    if (type == "login") {
      var response = await ApiServices().postDataWithToken(
          data, "/rest/V1/carts/mine/shipping-information", false);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        return "success";
      }
    } else {
      var response = await ApiServices().postData(data,
          "/rest/V1/guest-carts/$guestQuoteId/shipping-information", false);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        return "success";
      }
    }

    // }
    //  catch (e) {
    //   return "success";
    // }
  }

  Future<CartResponseModel?> addProductCartLogin(
      {sku,
      primaryqty = 0,
      qty,
      colorId = 0,
      sizeId = 0,
      productType = "simple",
      colorOprionId = 0,
      sizeOptionId = 0}) async {
    var quoteId = box.read("quoteIdLogin");

    setAddtoCartLoader(true);

    Map<String, dynamic> data = {
      "cartItem": {"sku": "$sku", "qty": qty, "quote_id": "$quoteId"},
    };
    if (productType == "configurable") {
      if (colorId != 0 && sizeId == 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$colorOprionId", "option_value": "$colorId"}
            ]
          }
        };
      }
      if (colorId == 0 && sizeId != 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$sizeOptionId", "option_value": "$sizeId"}
            ]
          }
        };
      }
      if (colorId != 0 && sizeId != 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$colorOprionId", "option_value": "$colorId"},
              {"option_id": "$sizeOptionId", "option_value": "$sizeId"}
            ]
          }
        };
      }
    }

    try {
      //Jk
      // setLoader(true);
      var response = await ApiServices()
          .postDataWithToken(data, "/rest/V1/carts/mine/items", false);

      var body = json.decode(response.body);

      if (response.statusCode == 200) {
        _cartResponseModel = CartResponseModel.fromJson(body);

        await getCartTotalGstList();
        await getCartProductDetailsLogin();

        await box.write("cartQuoteId", _cartResponseModel!.quoteId);
      }
    } catch (e) {
      return _cartResponseModel;
    }
    //Jk
    // setLoader(false);

    // Jk
    // if (_cartResponseModel!.itemId != null) {
    setAddtoCartLoader(false);
    // }

    return _cartResponseModel;
  }

  /// update products
  Future<CartResponseModel?> updateProductCartLogin(
      {sku,
      primaryqty = 0,
      qty,
      productid,
      colorId = 0,
      sizeId = 0,
      productType = "simple",
      colorOprionId = 0,
      sizeOptionId = 0}) async {
    var quoteId = box.read("quoteIdLogin");

    setAddtoCartLoader(true);

    var data = {
      "cartItem": {"sku": "$sku", "qty": qty, "quote_id": "$quoteId"},
    };

    if (productType == "configurable") {
      if (colorId != 0 && sizeId == 0) {
        data['cartItem']!['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$colorOprionId", "option_value": "$colorId"}
            ]
          }
        };
      }
      if (colorId == 0 && sizeId != 0) {
        data['cartItem']!['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$sizeOptionId", "option_value": "$sizeId"}
            ]
          }
        };
      }
      if (colorId != 0 && sizeId != 0) {
        data['cartItem']!['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$colorOprionId", "option_value": "$colorId"},
              {"option_id": "$sizeOptionId", "option_value": "$sizeId"}
            ]
          }
        };
      }
    }

    try {
      //Jk
      // setLoader(true);
      setAddtoCartLoader(true);

      final response = await ApiServices().putDataWithToken(
          data, "/rest/V1/carts/mine/items/$productid", false);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        _cartResponseModel = CartResponseModel.fromJson(body);
      }
    } catch (e) {
      return _cartResponseModel;
    }
    //Jk
    // setLoader(false);

    await getCartProductDetailsLogin();
    await getCartTotalGstList();

    // if (_cartResponseModel!.itemId != null) {}

    setAddtoCartLoader(false);

    return _cartResponseModel;
  }

  Future<Object> deleteLoginProduct({productid}) async {

    setAddtoCartLoader(true);

    var response = await ApiServices()
        .deleteData("", "/rest/V1/carts/mine/items/$productid", false);
    var body = json.decode(response.body);

    notifyListeners();

    if (response.statusCode == 200) {
      getCartProductDetailsLogin();
      notifyListeners();

      setAddtoCartLoader(false);

      return "Success";
    } else {
      setAddtoCartLoader(false);
      return body['message'];
    }
  }

  //// GUEST

  Future<Object> deleteguestProduct({productid}) async {
    var quoteid = box.read("quoteIdGuest");

    setAddtoCartLoader(true);

    var response = await ApiServices().deleteData(
        "", "/rest/V1/guest-carts/$quoteid/items/$productid", false);
    var body = json.decode(response.body);

    notifyListeners();
    if (response.statusCode == 200) {
      getCartProductDetailsGuest();

      notifyListeners();

      setAddtoCartLoader(false);

      return "Success";
    } else {
      setAddtoCartLoader(false);

      return body['message'];
    }
  }

  Future<Object> guestUsers() async {
    var response =
        await ApiServices().postData("", "/rest/V1/guest-carts", false);
    var body = json.decode(response.body);

    box.write("quoteIdGuest", body);

    notifyListeners();
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return body['message'];
    }
  }

  Future<void> intialCall() async {
    setLoader2(true);
    await getCartProductDetailsGuest();
    setLoader2(false);
  }

  Future<void> intialCallGst() async {
    setLoader2(true);
    await getCartTotalGstList();
    setLoader2(false);
  }

  Future<GuestCartResponsemodel?> getCartProductDetailsGuest() async {
    var guestQuiteId = box.read("quoteIdGuest");

    try {
      // setLoader2(true);
      var response = await ApiServices().getDataValue(
        "/rest/V1/guest-carts/$guestQuiteId",
      );

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _guestCartList = GuestCartResponsemodel.fromJson(jsonMap);
        var storeid = _guestCartList!.storeId;
        box.write("storeId", storeid);
        await cartPageGetGstDeliveryamount(type: "guest");
      }
    } catch (e) {
      return _guestCartList;
    }
    // setLoader2(false);

    totalPriceValue2(_guestCartList!);
    moreVAlue();
    _cartCount = int.parse("${_guestCartList!.itemsQty}");
    changeCartTotalCount(_cartCount);

    if (_guestCartList!.items!.isNotEmpty) {
    }

    return _guestCartList;
  }

  Future<CartResponseModel?> addProductCartGuest(
      {sku,
      primaryqty = 0,
      qty,
      colorId = 0,
      sizeId = 0,
      productType = "simple",
      colorOprionId = 0,
      sizeOptionId = 0}) async {
    var guestQuiteId = box.read("quoteIdGuest");

    setAddtoCartLoader(true);

    Map<String, dynamic> data = {
      "cartItem": {"sku": "$sku", "qty": qty, "quote_id": "$guestQuiteId"},
    };
    if (productType == "configurable") {
      if (colorId != 0 && sizeId == 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$colorOprionId", "option_value": "$colorId"}
            ]
          }
        };
      }
      if (colorId == 0 && sizeId != 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$sizeOptionId", "option_value": "$sizeId"}
            ]
          }
        };
      }
      if (colorId != 0 && sizeId != 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$colorOprionId", "option_value": "$colorId"},
              {"option_id": "$sizeOptionId", "option_value": "$sizeId"}
            ]
          }
        };
      }
    }

    try {
      // setCommonLoader(true);
      var response = await ApiServices()
          .postData(data, "/rest/V1/guest-carts/$guestQuiteId/items", false);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        _cartResponseModel = CartResponseModel.fromJson(body);
      } else {
        return CartResponseModel.fromJson(
            {'status': data['status'], 'message': data['message']});
      }
    } catch (e) {
      return _cartResponseModel;
    }

    await getCartProductDetailsGuest();
    await getGuestTotalGstList();
    // setCommonLoader(false);
    await box.write("cartQuoteId", _cartResponseModel!.quoteId);

    setAddtoCartLoader(false);

    // if (_cartResponseModel!.itemId != null) {
    //   setAddtoCartLoader(false);
    // }

    return _cartResponseModel;
  }

  Future<GuestAddUpdateCartModel?> updateProductCartGuest(
      {sku,
      qty,
      primaryqty = 0,
      productid,
      colorId = 0,
      sizeId = 0,
      productType = "simple",
      colorOprionId = 0,
      sizeOptionId = 0}) async {
    var quoteId = box.read("quoteIdGuest");

    setAddtoCartLoader(true);

    Map<String, dynamic> data = {
      "cartItem": {"sku": "$sku", "qty": qty, "quote_id": "$quoteId"}
    };

    if (productType == "configurable") {
      if (colorId != 0 && sizeId == 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$colorOprionId", "option_value": "$colorId"}
            ]
          }
        };
      }
      if (colorId == 0 && sizeId != 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$sizeOptionId", "option_value": "$sizeId"}
            ]
          }
        };
      }
      if (colorId != 0 && sizeId != 0) {
        data['cartItem']['product_option'] = {
          "extension_attributes": {
            "configurable_item_options": [
              {"option_id": "$colorOprionId", "option_value": "$colorId"},
              {"option_id": "$sizeOptionId", "option_value": "$sizeId"}
            ]
          }
        };
      }
    }

    try {
      //Jk
      // setLoader(true);
      var response = await ApiServices().putData(
          data, "/rest/V1/guest-carts/$quoteId/items/$productid", false);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        _guestCartAddUpdateList = GuestAddUpdateCartModel.fromJson(body);

        await getCartProductDetailsGuest();
        await getGuestTotalGstList();
      }
    } catch (e) {
      return _guestCartAddUpdateList;
    }
    //Jk
    // setLoader(false);

    setAddtoCartLoader(false);

    // if (_cartResponseModel!.itemId != null) {
    //   setAddtoCartLoader(false);
    // }

    return _guestCartAddUpdateList;
  }

  Future<CartResponseModel?> mergeToCustomerCart({sku, qty}) async {
    var guestQuiteId = box.read("quoteIdGuest");

    var data = {"customerId": 18, "storeId": 1};
    try {
      setLoader2(true);
      var response = await ApiServices()
          .postData(data, "/rest/V1/guest-carts/$guestQuiteId", false);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        _cartResponseModel = CartResponseModel.fromJson(body);
      }
    } catch (e) {
      return _cartResponseModel;
    }
    setLoader2(false);
    return _cartResponseModel;
  }

  /// GET PROFILE DATA

  Future<ProfileDataModel?> getProfileData({token}) async {
    try {
      setLoader2(true);
      var response =
          await ApiServices().getDataValueWith("/rest/V1/customers/me", token);
      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);
        _profileDataList = ProfileDataModel.fromJson(jsonMap);
        var id = _profileDataList!.id;
        box.write("customerId", id);
        _profileInformation = [
          "${_profileDataList!.email}",
          "${_profileDataList!.firstname}",
          "${_profileDataList!.lastname}"
        ];

        box.write("profileInfo", _profileInformation);

        var ide = box.read("customerId");

        if (box.read("quoteIdGuest") != null && ide != null) {
          mergeguest(customerId: ide);
        }
      }
    } catch (e) {
      return _profileDataList;
    }
    setLoader2(false);

    return _profileDataList;
  }

  Future<CartResponseModel?> addToWishlist({sku, qty}) async {
    var guestQuiteId = box.read("quoteIdGuest");

    var data = {
      "cartItem": {"sku": "$sku", "qty": qty, "quote_id": "$guestQuiteId"},
    };
    try {
      setLoader3(true);
      var response = await ApiServices()
          .postData(data, "/rest/V1/guest-carts/$guestQuiteId/items", false);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        _cartResponseModel = CartResponseModel.fromJson(body);
      }
    } catch (e) {
      return _cartResponseModel;
    }
    getCartProductDetailsGuest();
    setLoader3(false);
    return _cartResponseModel;
  }

  /// Cart GST
  Future<GrandTotalGstModel?> getCartTotalGstList() async {
    var token = box.read("token");

    try {
      // setLoader2(true);
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

    notifyListeners();

    return _cartTotalGstList;
  }

  Future<GrandTotalGstModel?> getGuestTotalGstList() async {
    var guestQuoteId = box.read("quoteIdGuest");
    try {
      setLoader(true);
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
    setLoader(false);

    return _guestTotalGstList;
  }

//Clear cart
  Future<Object> clearCart() async {
    // var quoteId = box.read("quoteIdGuest") ?? box.read("quoteIdLogin");
    var quoteId = box.read("cartQuoteId");

    var data = {"quote_id": quoteId};
    var response = await ApiServices()
        .postData(data, "/rest/V1/fazmmi-apis/clearcart", false);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      changeCartTotalCount(0);
      box.read("quoteIdGuest") != null
          ? getCartProductDetailsGuest()
          : getCartProductDetailsLogin();
      notifyListeners();

      return "Success";
    } else {
      return body['message'];
    }
  }

/*
|----------
| CART SECTION
|---------- 
*/

  /* ---------initialize cart model------*/
  login_cart.ViewCartPageModel? _loginCartList;
  login_cart.ViewCartPageModel? get loginCartList => _loginCartList;
  GuestCartResponsemodel? _guestCarttList;
  GuestCartResponsemodel? get guesttCarttList => _guestCarttList;

  int? _itemIndex = 0;
  int? get itemIndex => _itemIndex;
  loadCartDataFnc() async {
    if (quoteId != null || guestQuiteId == null) {
      _loginCartList = await getCartProductDetailsLogin();

      /* load fouvorite list */
      loadFavourite();
      /* end */
    } else if (quoteId == null || guestQuiteId != null) {
      _guestCarttList = await getCartProductDetailsGuest();
    } else {
      return;
    }
    notifyListeners();
  }

  checkIsCart({sku}) {
    Iterable<Object>? isCart;
    if (quoteId != null || guestQuiteId == null) {
      isCart = _loginCartList!.items!.where((ele) => ele.sku == sku);
      return isCart;
    } else if (quoteId == null || guestQuiteId != null) {
      isCart = _guestCarttList!.items!.where((ele) => ele.sku == sku);
      return isCart;
    } else {
      return;
    }
  }

  Future addCartFnc(
      {sku, qty, productid, index, categoryId, storeId, page, loadVar}) async {
    // print("$sku,$qty,$productid");
    // print(qty);
    // print(productid);

    setCartIndex(index);

    _itemIndex = index;
    notifyListeners();


    bool retRes = false;
    setLoadState('_isCartLoad', true);

    if (quoteId != null || guestQuiteId == null) {
      if (qty > 0) {
      } else if (qty == 0) {
      }
    }
    /* ----for guest user---- */
    else if (quoteId == null || guestQuiteId != null) {
      if (qty == 0) {
        retRes = true;
      } else if (qty > 0) {
        retRes = true;
      }
    } else {
      // setLoadState('_isCartLoad', false);
      return;
    }
    // await fetchFeaturedProduct(
    //     categoryId: categoryId, loadVar: loadVar, page: page, storeId: storeId);

    // Future.delayed(const Duration(milliseconds: 500), () {
    _itemIndex = null;
    notifyListeners();
    setLoadState('_isCartLoad', false);
    // });
    return retRes;
  }

  deleteCartFnc({sku, qty, productid, index}) {
    _itemIndex = index;

    setCartIndex(index);

    // Jk
    // var response;

    bool retRes = false;
    // setLoadState('_isCartLoad', true);

    /* ----for logged user---- */
    if (quoteId != null || guestQuiteId == null) {
      if (qty > 1) {
        updateProductCartLogin(qty: qty - 1, sku: sku, productid: productid);
      } else if (qty == 1) {
        deleteLoginProduct(productid: productid);
      }
    }
    /* ----for guest user---- */
    else if (quoteId == null || guestQuiteId != null) {
      if (qty == 1) {
        deleteguestProduct(productid: productid);
        retRes = true;
      } else if (qty > 1) {
        updateProductCartGuest(qty: qty - 1, sku: sku, productid: productid);
        retRes = true;
      }
    } else {
      // setLoadState('_isCartLoad', false);
      return;
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _itemIndex = null;
      notifyListeners();
      // setLoadState('_isCartLoad', false);
    });

    return retRes;
  }

  //// Delivery fee

  DeliveryFeeModel? _deliveryfee;
  DeliveryFeeModel? get deliveryfee => _deliveryfee;

  bool _deliveryloader = false;
  bool get deliveryloader => _deliveryloader;

  setDeliveryLoader(bool val) {
    _deliveryloader = val;
    notifyListeners();
  }

  Future<DeliveryFeeModel?> getDeliveryFee() async {
    setDeliveryLoader(true);
    var data = {
      "address": {"country_id": "IN", "postcode": "686601"}
    };
    var response = await ApiServices().postDataWithToken(
        data, "/rest/V1/carts/mine/estimate-shipping-methods", false);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      _deliveryfee = DeliveryFeeModel.fromJson(body[0]);
      setDeliveryLoader(false);
      return _deliveryfee;
    } else {
      _deliveryfee = null;
      return null;
    }
  }
}
