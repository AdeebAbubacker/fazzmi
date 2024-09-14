import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share/share.dart';
import '../presentaion/productDetailPage/screenProductDetailPage.dart';

typedef DeepLinkSuccess = void Function(Uri);

class DynamicLinks {
  late FirebaseDynamicLinks _dynamicLinks;

  static late DynamicLinks _instance;
  final box = GetStorage();

  // final _prefs = SharedPreferencesRepo.instance;

  DynamicLinks._(FirebaseDynamicLinks inst) {
    _dynamicLinks = inst;
  }

  static void initialize(FirebaseDynamicLinks links) {
    _instance = DynamicLinks._(links);
  }

  static DynamicLinks get instance => _instance;

  Future<void> createDynamicLink(String productName, int qty, String sku,
      String shopType, String storeName,
      {bool short = true}) async {
    String domain = "https://fazzmi.page.link/shop";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: domain,
      link: Uri.parse(
          'https://www.fazzmi.com/shop?productName=$productName&qty=$qty&sku=$sku&shoptype=$shopType&storeName=$storeName'),
      androidParameters: const AndroidParameters(
        packageName: 'com.fazzmi.app',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "Bundle-ID",
        minimumVersion: '0',
      ),
      // socialMetaTagParameters:
      //     SocialMetaTagParameters(description: '', title: title),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await _dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await _dynamicLinks.buildLink(parameters);
    }

    await Share.share(
      url.toString(),
      subject: 'Try $productName',
    );
  }

  Future<void> initDynamicLink(BuildContext context) async {
    if (kDebugMode) {}

    // This method will work only when the app is opened from dynamic link in terminated app state
    final PendingDynamicLinkData? data = await _dynamicLinks.getInitialLink();
    if (data != null) {
      final Uri? deepLink = data.link;
      if (deepLink != null) {
        final queryParams = deepLink.queryParameters;
        _handleMyLink(queryParams, context);
      }
    }

    // This method will work when the app is opened from dynamic link in foreground or background app state
    _dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      _handleMyLink(queryParams, context);
    }).onError((error) {
      if (kDebugMode) {
        print(error.message);
      }
    });
  }

  void _handleMyLink(Map<String, String> queryParams, BuildContext context) {
    if (queryParams.isNotEmpty) {
      String? productName = queryParams["productName"];
      String? qty = queryParams["qty"];
      String? sku = queryParams["sku"];
      String? shopType = queryParams["shopType"];
      String? storeName = queryParams["storeName"];

      if (productName != null) {
        // if (_prefs.isUserLoggedIn == null) {
        //   return;
        // }
        // if (!_prefs.isUserLoggedIn!) {
        //   return;
        // }

        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return ScreenProductDetail(
            parentCategoryId: "3",
            storeId: 1,
            productId: 1,
            wishList: true,
            productName: productName,
            qty: int.parse(qty!),
            sku: sku!,
            shopType: shopType!,
            storeName: storeName!,
          );
        }));

        // navigatorKey.currentState?.push(MaterialPageRoute(builder: (ctx) {
        //   return VendorProductsScreen(
        //     vendorId: id,
        //     vendorName: name,
        //     fromDeeplink: true,
        //   );
        // }));
      }
    }
  }
}
