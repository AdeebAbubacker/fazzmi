import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:fazzmi/model/DealsProductModel/deals_product_model.dart';
import 'package:fazzmi/model/categorymodel/category_model.dart';
import 'package:fazzmi/model/deals_shop_by_category_model/deals_shopbycategory_model.dart';
import 'package:fazzmi/model/dealsproductcategorymodel/deals_product_deals_model.dart';
import 'package:fazzmi/model/homepageads/homepage_ads_model.dart';
import 'package:fazzmi/model/store_category_model/store_category_model.dart';
import 'package:fazzmi/model/storesubcategorymodel/store_subcategory_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../model/addressModel/addressModel.dart';
import '../model/cart_response_model/cart_response_model.dart';
import '../model/cartproductlist/cart_product_list.dart';
import '../model/featuredProductModel/featuredProductModel.dart';
import '../model/subcategorymodel/sub_category_model.dart';

final box = GetStorage();
var token = box.read("token");

class ApiServices {
  var token = box.read("token");

  final String baseUrl = "https://staging.fazzmi.com";

  getData(endUrl) {
    var url = baseUrl + endUrl;
    var response = http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    log("ApiServices [getData] - token ::::::::: $token");
    return response;
  }

  getDataValue(endUrl) async {
    var url = baseUrl + endUrl;

    return await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer yajlqqlju6uewudbb5vudmt7swwp5041',
      'Cookie':
          'PHPSESSID=l73mud80ic56asmcubfut4jabq; mage-messages=%5B%7B%22type%22%3A%22error%22%2C%22text%22%3A%22Invalid%20Form%20Key.%20Please%20refresh%20the%20page.%22%7D%2C%7B%22type%22%3A%22error%22%2C%22text%22%3A%22Invalid%20Form%20Key.%20Please%20refresh%20the%20page.%22%7D%5D; private_content_version=859258a601c1843fc0a67fe8c39a18e3'
    });
  }

  getDataValueWith(endUrl, tokens) async {
    var url = baseUrl + endUrl;

    return await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
      'Cookie':
          'PHPSESSID=l73mud80ic56asmcubfut4jabq; mage-messages=%5B%7B%22type%22%3A%22error%22%2C%22text%22%3A%22Invalid%20Form%20Key.%20Please%20refresh%20the%20page.%22%7D%2C%7B%22type%22%3A%22error%22%2C%22text%22%3A%22Invalid%20Form%20Key.%20Please%20refresh%20the%20page.%22%7D%5D; private_content_version=859258a601c1843fc0a67fe8c39a18e3'
    });
  }

  postData(data, endUrl, contentType) async {
    String contenttype = contentType
        ? 'application/json;'
        : 'application/x-www-form-urlencoded; charset=UTF-8';
    var url = baseUrl + endUrl;

    return await http.post(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
  }

  deleteData(data, endUrl, contentType) async {
    String contenttype = contentType
        ? 'application/json;'
        : 'application/x-www-form-urlencoded; charset=UTF-8';
    var url = baseUrl + endUrl;
    return await http.delete(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  postDataWithToken(data, endUrl, contentType) async {
    // String contenttype = contentType
    //     ? 'application/json;'
    //     : 'application/x-www-form-urlencoded; charset=UTF-8';
    var url = baseUrl + endUrl;

    return await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  postDataWithAdminToken(data, endUrl, contentType) async {
    String contenttype = contentType
        ? 'application/json;'
        : 'application/x-www-form-urlencoded; charset=UTF-8';
    var url = baseUrl + endUrl;

    return await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer yajlqqlju6uewudbb5vudmt7swwp5041',
    });
  }

  putDataWithToken(data, endUrl, contentType) async {
    String contenttype = contentType
        ? 'application/json;'
        : 'application/x-www-form-urlencoded; charset=UTF-8';
    var url = baseUrl + endUrl;

    return await http.put(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  putData(data, endUrl, contentType) async {
    String contenttype = contentType
        ? 'application/json;'
        : 'application/x-www-form-urlencoded; charset=UTF-8';
    var url = baseUrl + endUrl;
    return await http.put(Uri.parse(url),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
  }

  Future<CartResponseModel> cartResponse({sku, qty}) async {
    var quoteId = box.read("quoteId");
    var _cartresponse;
    var data = {
      "cartItem": {"sku": "$sku", "qty": qty, "quote_id": "$quoteId"},
    };

    try {
      var response =
          await postDataWithToken(data, "/rest/V1/carts/mine/items", false);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        _cartresponse = CartResponseModel.fromJson(body);
      }
    } catch (e) {
      return _cartresponse;
    }

    return _cartresponse;
  }

  Future<dynamic> loginForm(email, password) async {
    var data = {'username': email, "password": password};
    var response = await postData(
        data, "/rest/default/V1/integration/customer/token", true);

    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      var res = {'success': 'success', 'body': body};
      box.write("token", body);

      return res;
    } else {
      var res = {'success': 'not', 'body': body};

      return res;
    }
  }

  Future<dynamic> loginWithFacebookOrGoogle(
      name, email, uId, phoneNumber, sourceOfLogin) async {
    var data = {
      "name": name,
      "email": email,
      "u_id": uId,
      "phone": phoneNumber,
      "source_of_login": sourceOfLogin
    };

    var response = await postDataWithAdminToken(
        data, "/rest/V1/fazmmi-apis/socialmedialogin", true);

    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      var res = {'success': 'success', 'body': body};
      var quoteId = body["data"]["quoteId"];

      box.write("token", quoteId);

      var token = box.read("token");

      return res;
    } else {
      var res = {'success': 'not', 'body': body};

      return res;
    }
  }

  Future<Object> signUpForm(email, password, firstname, lastname) async {
    var data = {
      "customer": {
        "email": email,
        "firstname": firstname,
        "lastname": lastname
      },
      "password": password
    };
    var response = await postData(data, "/rest/default/V1/customers", false);

    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      return "Success";
    } else {
      return body['message'];
    }
  }

  /// CHANGE PASSWORD

  Future<Object> changePassword({currentPassword, newPaswword}) async {
    var data = {
      "currentPassword": "$currentPassword",
      "newPassword": "$newPaswword"
    };
    var response =
        await putDataWithToken(data, "/rest/V1/customers/me/password", false);

    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      return "Success";
    } else {
      return body['message'];
    }
  }

  /// UPDATE PROFILE DATA

  Future<Object> updateProfileData({email, firstname, lastname}) async {
    var data = {
      "customer": {
        "email": "$email",
        "firstname": "$firstname",
        "lastname": "$lastname",
        "website_id": 1
      }
    };
    var response = await putDataWithToken(data, "/rest/V1/customers/me", false);

    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      return "Success";
    } else {
      return body['message'];
    }
  }

  Future<HomePageAds> getHomepageadsSlider(storeid) async {
    var _homePageAdsList;
    try {
      var response = await getDataValue(
          "/rest/default/V1/fazmmi-apis/homeads?store_id=$storeid");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _homePageAdsList = HomePageAds.fromJson(jsonMap);
      }
    } catch (e) {
      return _homePageAdsList;
    }

    return _homePageAdsList;
  }

  /// main category
  Future<CategoryModel> getMainCategory() async {
    var _mainCategoryList;

    var pincode = box.read("actualpinCode");
    // try {

    var response = await getDataValue(
        "/rest/V1/fazmmi-apis/getcategories/featuredproducts?postcode=$pincode");

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);
      _mainCategoryList = CategoryModel.fromJson(jsonMap);
      return _mainCategoryList;
    } else {
      return _mainCategoryList;
    }
    // } catch (e) {

    //   return _mainCategoryList;
    // }
  }

  Future<DealsShopBycategoryModel> getDealsShopByCategory() async {
    var _deals_shopByCategoryList;

    try {
      var response =
          await getDataValue("/rest/default/V1/fazmmi-apis/getcategory?id=15");
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _deals_shopByCategoryList = DealsShopBycategoryModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _deals_shopByCategoryList;
    }
    return _deals_shopByCategoryList;
  }

  Future<DealsProductModel> getDealsProduct() async {
    var _dealsProductList;
    try {
      var response = await getDataValue(
          "/rest/V1/products?searchCriteria[filterGroups][0][filters][0][conditionType]=eq&searchCriteria[filterGroups][0][filters][0][field]=category_id&searchCriteria[filterGroups][0][filters][0][value]=15");
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _dealsProductList = DealsProductModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _dealsProductList;
    }
    return _dealsProductList;
  }

  /// GROCERY CATEGORY

  Future<SubCategoryModel> getSubCategoryList(id) async {
    var _getsubCategoryList;
    try {
      var response =
          await getDataValue("/rest/default/V1/fazmmi-apis/getcategory?id=$id");
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _getsubCategoryList = SubCategoryModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _getsubCategoryList;
    }
    return _getsubCategoryList;
  }

  /// GROCERY VERTICAL CATEGORY

  Future<StoreCategoryModel> getStoreCategoryList(id) async {
    var _storeCategoryList;
    try {
      var response = await ApiServices().getDataValue(
          "/rest/default/V1/fazmmi-apis/getCategoryStore?category_id=$id");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _storeCategoryList = StoreCategoryModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _storeCategoryList;
    }
    return _storeCategoryList;
  }

  /// SHOP BY CATEGORY
  Future<StoreSubCategoryModel> getStoreProductDeatils(
      {storeId, parentCategoryId}) async {
    var _storeProductlist;

    try {
      var response = await getDataValue(
          "/rest/V1/fazmmi-apis/getStore?store_id=$storeId&category_id=$parentCategoryId");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _storeProductlist = StoreSubCategoryModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _storeProductlist;
    }
    return _storeProductlist;
  }

  /// DEALS
  Future<DealsStoreCategoryModel> getDealsStoreProducts() async {
    var _dealsStoreProductList;
    var postCode = box.read("actualpinCode");

    try {
      var response = await ApiServices().getDataValue(
          "/rest/default/V1/fazmmi-apis/getDealsStores?postcode=$postCode");
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _dealsStoreProductList = DealsStoreCategoryModel.fromJson(jsonMap);
      }
    } catch (e) {
      _dealsStoreProductList;
    }
    return _dealsStoreProductList;
  }

  Future<ViewCartPageModel> getCartProductDetails() async {
    var token = box.read("token");
    var _getCartProductsList;
    try {
      var response = await getDataValueWith("/rest/V1/carts/mine", token);

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _getCartProductsList = ViewCartPageModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _getCartProductsList;
    }

    return _getCartProductsList;
  }

  /// ADD ADDRESS AND DELETE ADDRESS AND GET

  Future<Object> addAddress({data, isAdd, addId = ''}) async {
    var url = isAdd
        ? "/rest/V1/customer/address/"
        : "/rest/V1/customer/address/$addId";
    var response;

    if (isAdd) {
      response = await postDataWithToken(data, url, false);
    } else {
      response = await putData(data, url, false);
    }

    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      return "Success";
    } else {
      return body['message'];
    }
  }

  Future<Object> deleteAddress({addressId}) async {
    var quoteid = box.read("quoteIdGuest");
    var response =
        await deleteData("", "/rest/V1/customer/address/$addressId", false);
    var body = json.decode(response.body);

    if (response.statusCode == 200) {
      return "Success";
    } else {
      return body['message'];
    }
  }

  Future<List<AddressData>?> getAddressBook() async {
    List<AddressData>? _addressList = [];
    try {
      var customerId = box.read("customerId") ?? 1;
      var response =
          await getDataValue("/rest/V1/customer/address/$customerId");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        var list = jsonMap['data'] as List;
        _addressList = list.map((p) => AddressData.fromJson(p)).toList();
      }
    } catch (e) {
      return _addressList;
    }
    return _addressList;
  }

  /* get featured products */
  getFeaturedProduct({categoryId, storeId, page}) async {
    FeaturedProductModel? _featuredProduct;

    try {
      var response = await getDataValue(
          "/rest/V1/listproducts/$categoryId/store/$storeId/page/$page");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _featuredProduct = FeaturedProductModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _featuredProduct;
    }

    return _featuredProduct;
  }

  /// forgot password

  Future<dynamic> sendForgotOTP(email) async {
    var data = {"email": "$email", "template": "email_reset"};
    var res;
    var response =
        await ApiServices().putData(data, "/rest/V1/customers/password", true);
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      res = {'success': 'success', 'body': body};
    } else {
      res = {'success': 'not', 'body': body};
    }
    return res;
  }

  Future<dynamic> forgotPasswordForm(email, password, otp) async {
    var data = {
      "email": "$email",
      "resetToken": "$otp",
      "newPassword": "$password"
    };

    Map<String, dynamic> res;
    var response =
        await postData(data, "/rest/V1/customers/resetPassword", true);
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      res = {'success': 'success', 'body': body};
    } else {
      res = {'success': 'not', 'body': body};
    }
    return res;
  }

  Future<dynamic> sendPhoneVerifyOTP(phone) async {
    var data = {"email": "$phone", "template": "phone_verify"};
    var res;
    var response = await postData(data, "/rest/V1/customers/password", true);
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      res = {'success': 'success', 'body': body};
    } else {
      res = {'success': 'not', 'body': body};
    }
    return res;
  }
}
