// import 'package:fazzmi/presentaion/product_detail_2/screenProductDetailPage.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';

// class DynamicLinkService {
//   Future<void> retrieveDynamicLink(BuildContext context) async {
//     try {
//       final PendingDynamicLinkData? data =
//           await FirebaseDynamicLinks.instance.getInitialLink();
//       final Uri? deepLink = data?.link;

//       if (deepLink != null) {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => ScreenProductDetail(
//                   productName: "Shirt",
//                   qty: 0,
//                   sku: "shirt",
//                   shopType: "2",
//                   storeName: "Store 2",
//                 )));
//       }

//       dynamicLinks.onLink.listen((dynamicLinkData) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ScreenProductDetail(
//                       productName: "Shirt",
//                       qty: 0,
//                       sku: "shirt",
//                       shopType: "2",
//                       storeName: "Store 2",
//                     )));

//         // Navigator.of(context).push(MaterialPageRoute(
//         //     builder: (context) => ScreenProductDetail(
//         //           productName: "Shirt",
//         //           qty: 0,
//         //           sku: "shirt",
//         //           shopType: "2",
//         //           storeName: "Store 2",
//         //         )));
//       }).onError((error) {
//       
//       
//       });
//       // FirebaseDynamicLinks.instance.onLink();

//       // FirebaseDynamicLinks.instance.onLink.listen(
//       //     onSuccess: (PendingDynamicLinkData dynamicLink) async {
//       //   Navigator.of(context).push(MaterialPageRoute(
//       //       builder: (context) => ScreenProductDetail(
//       //             productName: "Shirt",
//       //             qty: 0,
//       //             sku: "shirt",
//       //             shopType: "2",
//       //             storeName: "Store 2",
//       //           )));
//       // });
//     } catch (e) {
//     
//     }
//   }

//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

//   Future<Uri> createDynamicLink() async {
//   
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://fazzmi.page.link',
//       link: Uri.parse('https://fazzmi.com'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.fazzmi.app',
//         minimumVersion: 1,
//       ),
//     );
//     final ShortDynamicLink shortLink =
//         await dynamicLinks.buildShortLink(parameters);

//     final Uri shortUrl = shortLink.shortUrl;
//     return shortUrl;
//   }
// }
