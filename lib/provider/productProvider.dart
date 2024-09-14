// import 'dart:convert';
// import 'dart:developer';
// import 'package:fazzmi/model/GuestCartResponsemodell/guestCart_response_model.dart';
// import 'package:fazzmi/model/cartproductlist/cart_product_list.dart'
//     as login_cart;
// import 'package:fazzmi/model/wishlist/wishlist_model.dart';
// import 'package:fazzmi/provider/cartInStore.dart';
// import 'package:fazzmi/services/api_services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../model/featuredProductModel/featuredProductModel.dart';
// import '../model/storesubcategorymodel/store_subcategory_model.dart';

// class ProductProvider with ChangeNotifier {
//   StoreSubCategoryModel? _storesubCategoryList;
//   StoreSubCategoryModel? get storesubCategoryList => _storesubCategoryList;

//   int _index = 0;
//   int get index => _index;
//   setindex(value) {
//     _index = value;
//     notifyListeners();
//   }

//   bool _subcategoryloader = true;
//   bool get subcategoryloader => _subcategoryloader;
//   setSubCategoryLoader(bool val) {
//     _subcategoryloader = val;
//     notifyListeners();
//   }

//   bool _storeloader = true;
//   bool get storeloader => _storeloader;

//   setStoreLoader(bool val) {
//     _storeloader = val;
//     notifyListeners();
//   }

//   Future<StoreSubCategoryModel?> getSubCategoryList(
//       {id, parentCategoryId, index}) async {
//     setSubCategoryLoader(true);

//     try {
//       var response = await ApiServices().getDataValue(
//           "/rest/V1/fazmmi-apis/getStore?store_id=$id&category_id=$parentCategoryId");

//       if (response.statusCode == 200) {
//         var jsonMap = jsonDecode(response.body);
//         _storesubCategoryList = StoreSubCategoryModel.fromJson(jsonMap);

//         if (_storesubCategoryList!.data!.storeCategory!.isNotEmpty) {
//           int catId = int.parse(
//               _storesubCategoryList!.data!.storeCategory![index].categoryId!);

//           if (index == _index) {
//             fetchFeaturedProduct(
//                 categoryId: catId, page: 1, storeId: id, loadVar: "_isLoading");
//           }
//         }

//         notifyListeners();
//       }
//     } catch (e) {
//       return _storesubCategoryList;
//     }

//     setSubCategoryLoader(false);
//     return _storesubCategoryList;
//   }

//   BuildContext context;
//   ProductProvider(this.context);

//   /* ---------initialize product list model------*/
//   List<FeaturedProductItem>? _featuredProductList;
//   List<FeaturedProductItem>? get featuredProductList => _featuredProductList;

//   /* ---------initialize cart model------*/
//   login_cart.ViewCartPageModel? _loginCartList;
//   login_cart.ViewCartPageModel? get loginCartList => _loginCartList;
//   GuestCartResponsemodel? _guestCartList;
//   GuestCartResponsemodel? get guestCartList => _guestCartList;

// /* ---------initialize cart model------*/
//   ViewWishListModel? _favouriteList;
//   ViewWishListModel? get favouriteList => _favouriteList;

//   /* ---------initialize loader variable------*/
//   bool _isLoadMore = false, _isLoading = false, _isCartLoad = false;
//   bool get isLoadMore => _isLoadMore;
//   bool get isLoad => _isLoading;
//   bool get isCartLoad => _isCartLoad;
//   var guestQuiteId, quoteId;

//   int? _itemIndex = 0;
//   int? get itemIndex => _itemIndex;

//   int? _cartIndex;
//   int? get cartIndex => _cartIndex;
//   setCartIndex(int? index) {
//     _cartIndex = index;
//     notifyListeners();
//   }

//   initialState() {
//     guestQuiteId = boxguestQuiteId;
//     quoteId = box.read("quoteIdLogin");
//     notifyListeners();
//   }

//   setLoadState(String variable, bool value) {
//     switch (variable) {
//       case '_isLoading':
//         {
//           _isLoading = value;
//         }
//         break;
//       case '_isLoadMore':
//         {
//           _isLoadMore = value;
//         }
//         break;
//       case '_isCartLoad':
//         {
//           _isCartLoad = value;
//         }
//         break;
//       default:
//         break;
//     }
//     notifyListeners();
//   }

//   Future<List<FeaturedProductItem>?> fetchFeaturedProduct(
//       {loadVar, categoryId, storeId, page}) async {
//     // log("isComming");
//     // log("fetch featured product");
//     log("2 Cateid:$categoryId");

//     // log("load var:$loadVar");

//     // log("loading content $loadVar");

//     setLoadState(loadVar, true);

//     log("******************************   load var  $_isCartLoad");

//     var result = await ApiServices().getFeaturedProduct(
//         categoryId: categoryId, storeId: storeId, page: page);

//     _featuredProductList = result.data;

//     setLoadState(loadVar, false);
//     log("******************************   load var  $_isCartLoad");

//     return _featuredProductList;
//   }

// /*
// |----------
// | FAVOURITE SECTION
// |---------- 
// */

//   fetchFavourite({loadVar}) async {
//     setLoadState(loadVar, true);
//     await loadFavourite();
//     setLoadState(loadVar, false);
//   }

//   loadFavourite() async {
//     _favouriteList = await Provider.of<CartCounterStore>(context, listen: false)
//         .getWishList();
//     notifyListeners();
//   }

// /*
// |----------
// | CART SECTION
// |---------- 
// */

//   loadCartDataFnc() async {
//     if (quoteId != null || guestQuiteId == null) {
//       _loginCartList =
//           await Provider.of<CartCounterStore>(context, listen: false)
//               .getCartProductDetailsLogin();

//       /* load fouvorite list */
//       loadFavourite();
//       /* end */
//     } else if (quoteId == null || guestQuiteId != null) {
//       _guestCartList =
//           await Provider.of<CartCounterStore>(context, listen: false)
//               .getCartProductDetailsGuest();
//     } else {
//       return;
//     }
//     notifyListeners();
//   }

//   checkIsCart({sku}) {
//     Iterable<Object>? isCart;
//     if (quoteId != null || guestQuiteId == null) {
//       isCart = _loginCartList!.items!.where((ele) => ele.sku == sku);
//       return isCart;
//     } else if (quoteId == null || guestQuiteId != null) {
//       isCart = _guestCartList!.items!.where((ele) => ele.sku == sku);
//       return isCart;
//     } else {
//       return;
//     }
//   }

//   Future addCartFnc(
//       {sku, qty, productid, index, categoryId, storeId, page, loadVar}) async {
//     log("index :$index");
//     setCartIndex(index);

//     _itemIndex = index;
//     notifyListeners();
//     log(" add to cart");
//     var response;

//     bool retRes = false;
//     setLoadState('_isCartLoad', true);
//     log("******************************   load var  $_isCartLoad");

//     if (quoteId != null || guestQuiteId == null) {
//       if (qty > 0) {
//         response = Provider.of<CartCounterStore>(context, listen: false)
//             .updateProductCartLogin(
//                 qty: qty + 1, sku: sku, productid: productid);
//       } else if (qty == 0) {
//         response = Provider.of<CartCounterStore>(context, listen: false)
//             .addProductCartLogin(qty: qty + 1, sku: sku);
//       }
//     }
//     /* ----for guest user---- */
//     else if (quoteId == null || guestQuiteId != null) {
//       if (qty == 0) {
//         response = Provider.of<CartCounterStore>(context, listen: false)
//             .addProductCartGuest(qty: qty + 1, sku: sku);
//         retRes = true;
//       } else if (qty > 0) {
//         response = Provider.of<CartCounterStore>(context, listen: false)
//             .updateProductCartGuest(
//                 qty: qty + 1, sku: sku, productid: productid);
//         retRes = true;
//       }
//     } else {
//       // setLoadState('_isCartLoad', false);
//       return;
//     }
//     await fetchFeaturedProduct(
//         categoryId: categoryId, loadVar: loadVar, page: page, storeId: storeId);

//     // Future.delayed(const Duration(milliseconds: 500), () {
//     _itemIndex = null;
//     notifyListeners();
//     setLoadState('_isCartLoad', false);
//     // });
//     return retRes;
//   }

//   deleteCartFnc({sku, qty, productid, index}) {
//     _itemIndex = index;
//     setCartIndex(index);
//     var response;
//     bool retRes = false;
//     // setLoadState('_isCartLoad', true);
//     /* ----for logged user---- */
//     if (quoteId != null || guestQuiteId == null) {
//       if (qty > 1) {
//         response = Provider.of<CartCounterStore>(context, listen: false)
//             .updateProductCartLogin(
//                 qty: qty - 1, sku: sku, productid: productid);
//       } else if (qty == 1) {
//         response = Provider.of<CartCounterStore>(context, listen: false)
//             .deleteLoginProduct(productid: productid);
//       }
//     }
//     /* ----for guest user---- */
//     else if (quoteId == null || guestQuiteId != null) {
//       if (qty == 1) {
//         response = Provider.of<CartCounterStore>(context, listen: false)
//             .deleteguestProduct(productid: productid);
//         retRes = true;
//       } else if (qty > 1) {
//         response = Provider.of<CartCounterStore>(context, listen: false)
//             .updateProductCartGuest(
//                 qty: qty - 1, sku: sku, productid: productid);
//         retRes = true;
//       }
//     } else {
//       // setLoadState('_isCartLoad', false);
//       return;
//     }
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _itemIndex = null;
//       notifyListeners();
//       // setLoadState('_isCartLoad', false);
//     });
//     return retRes;
//   }

// /*
// |----------
// | FAVOURITE SECTION
// |---------- 
// */
//   checkIsFavourite({sku}) {
//     var isFavourite;
//     if (quoteId != null || guestQuiteId == null) {
//       isFavourite = _favouriteList!.data!.where((ele) => ele.sku == sku);
//       return isFavourite;
//     } else {
//       return;
//     }
//   }

//   changeFavourite({isAddFav, productid}) {
//     var response;
//     bool retRes = false;
//     setLoadState('_isCartLoad', true);
//     if (isAddFav) {
//       response = Provider.of<CartCounterStore>(context, listen: false)
//           .addfavorite(productId: productid);
//       retRes = true;
//     } else {
//       response = Provider.of<CartCounterStore>(context, listen: false)
//           .deletefavorite(productId: productid);
//       retRes = true;
//     }
//     loadFavourite();

//     Future.delayed(const Duration(milliseconds: 500), () {
//       setLoadState('_isCartLoad', false);
//     });
//     return retRes;
//   }
// }
