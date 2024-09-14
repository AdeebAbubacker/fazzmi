// import 'dart:math';
// import 'package:fazzmi/model/searchModel/searchModel.dart';
// import 'package:fazzmi/widgets/textInput.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../provider/searchPageprovider.dart';

// class ScreenSearch extends StatelessWidget {
//   ScreenSearch({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: buildAppBar(context),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // buildRecentSearch(context),
//           buildRecomendations(context),
//         ],
//       ),
//     );
//   }

//   OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//     borderSide: BorderSide(width: 1.0, color: Colors.grey.shade400),
//     borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//   );

//   buildAppBar(BuildContext context) {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(85),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 25.0),
//         child: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.white,
//             automaticallyImplyLeading: false,
//             title: SizedBox(
//               height: 55,
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   hintText: 'Search Products....',
//                   focusedBorder: outlineInputBorder,
//                   enabledBorder: outlineInputBorder,
//                   prefixIcon: const Icon(
//                     Icons.search_outlined,
//                     color: Colors.grey,
//                     size: 26,
//                   ),
//                   //  Image.asset(
//                   //     "images/serachicon.png",
//                   //     color: Colors.grey,
//                   //   ),
//                 ),
//                 onChanged: (value) {
//                   Provider.of<SearchPageProvider>(context, listen: false)
//                       .getSearchData(searchText: value);
//                 },
//                 onFieldSubmitted: (value) {
//                   // Provider.of<SearchPageProvider>(context, listen: false)
//                   //     .getSearchData(searchText: value);
//                 },
//               ),
//             )),
//       ),
//     );
//   }

//   // buildRecentSearch(BuildContext context) {
//   //   double width = MediaQuery.of(context).size.width;
//   //   return Container(
//   //     color: const Color.fromRGBO(246, 250, 255, 1),
//   //     padding: const EdgeInsets.only(left: 15),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         // const SizedBox(height: 10),
//   //         // const TextInput(
//   //         //     text1: "Recent Searchers", size: 21, weight: FontWeight.bold),
//   //         // const SizedBox(height: 10),
//   //         // buildRecentItemTile(width),
//   //         // const SizedBox(height: 25),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // buildRecentItemTile(double width) {
//   //   return SizedBox(
//   //     height: width / 4.5,
//   //     child: ListView(
//   //       scrollDirection: Axis.horizontal,
//   //       children: List.generate(
//   //         5,
//   //         (index) => Container(
//   //           // height: width / 3.6,
//   //           margin: const EdgeInsets.only(right: 5.0),
//   //           padding: const EdgeInsets.only(left: 8, bottom: 5),
//   //           width: width / 3.9,
//   //           alignment: Alignment.bottomLeft,
//   //           decoration: BoxDecoration(
//   //               borderRadius: BorderRadius.circular(10),
//   //               color:
//   //                   Colors.primaries[Random().nextInt(Colors.primaries.length)],
//   //               image: const DecorationImage(
//   //                 image: AssetImage('images/09_DEALS-51.png'),
//   //                 fit: BoxFit.fill,
//   //               )),
//   //           child: const TextInput(
//   //             text1: "Gents Pants",
//   //             size: 10,
//   //             weight: FontWeight.w700,
//   //             colorOfText: Colors.white,
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   buildRecomendations(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         child: Consumer<SearchPageProvider>(
//           builder: (context, value, child) {
//             // bool type = value.searchItem![0].products == [] ? false : true;
//             // var item = value.searchItem![0].products == []
//             //     ? value.searchItem![0].store
//             //     : value.searchItem![0].products;

//             List<Product?>? productItem = value.searchItem![0].products;
//             List<Store?>? storeItem = value.searchItem![0].store;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (value.searchItem!.isNotEmpty)
//                   // const TextInput(
//                   //     text1: "Recommendations ",
//                   //     size: 21,
//                   //     weight: FontWeight.bold),

//                   value.loader
//                       ? const Expanded(
//                           child: Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                         )
//                       : Expanded(
//                           child: value.searchItem!.isNotEmpty
//                               ? ListView(
//                                   children: List.generate(
//                                     value.searchItem!.length,
//                                     (index) => InkWell(
//                                       onTap: () {
//                                         // Navigator.push(
//                                         //     context,
//                                         //     MaterialPageRoute(
//                                         //         builder: (context) => type
//                                         //             ? ScreenProductDetail(
//                                         //                 storeId: int.parse(
//                                         //                     productItem![index]!
//                                         //                         .storeId!),
//                                         //                 parentCategoryId: productItem[index]!
//                                         //                     .parentCategoryId!,
//                                         //                 sku: productItem[index]!
//                                         //                     .sku!,
//                                         //                 qty: 1,
//                                         //                 productName: productItem[index]!
//                                         //                     .name!,
//                                         //                 shopType: productItem[index]!
//                                         //                     .shopType!,
//                                         //                 storeName: productItem[index]!
//                                         //                     .storeName!,
//                                         //                 wishList: true,
//                                         //                 productId: int.parse(
//                                         //                     productItem[index]!
//                                         //                         .id!))
//                                         //             : ScreenStores(
//                                         //                 storename: storeItem![index]!.name!,
//                                         //                 shoptype: int.parse(storeItem[index]!.shopType!),
//                                         //                 storeId: int.parse(storeItem[index]!.storeId!),
//                                         //                 parentCategoryId: storeItem[index]!.parentCategoryId!)));
//                                       },
//                                       child: Column(
//                                         children: [
//                                           productItem!.isNotEmpty
//                                               ? ListTile(
//                                                   contentPadding:
//                                                       const EdgeInsets.all(0),
//                                                   leading: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             25),
//                                                     child: Container(
//                                                       height: 50,
//                                                       width: 55,
//                                                       // color: primaryColor,
//                                                       child: Image.network(
//                                                         '${productItem[index]!.image!}',
//                                                         fit: BoxFit.fill,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   title: TextInput(
//                                                     text1:
//                                                         '${productItem[index]!.name!}',
//                                                     weight: FontWeight.w600,
//                                                     size: 14,
//                                                     maxLines: 2,
//                                                   ),
//                                                   subtitle: TextInput(
//                                                     size: 12,
//                                                     text1:
//                                                         '${productItem[index]!.name!}',
//                                                     colorOfText: Colors.grey,
//                                                   ),
//                                                 )
//                                               : const SizedBox(),
//                                           storeItem!.isNotEmpty
//                                               ? ListTile(
//                                                   contentPadding:
//                                                       const EdgeInsets.all(0),
//                                                   leading: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             25),
//                                                     child: Container(
//                                                       height: 50,
//                                                       width: 55,
//                                                       // color: primaryColor,
//                                                       child: Image.network(
//                                                         '${storeItem[index]!.image!}',
//                                                         fit: BoxFit.fill,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   title: TextInput(
//                                                     text1:
//                                                         '${storeItem[index]!.name!}',
//                                                     weight: FontWeight.w600,
//                                                     size: 14,
//                                                     maxLines: 2,
//                                                   ),
//                                                   subtitle: TextInput(
//                                                     size: 12,
//                                                     text1:
//                                                         '${storeItem[index]!.name!}',
//                                                     colorOfText: Colors.grey,
//                                                   ),
//                                                 )
//                                               : const SizedBox(),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : const Center(
//                                   child: Text('No data available!'),
//                                 ),
//                         ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // class SerachSingleWidget extends StatelessWidget {
// //   const SerachSingleWidget({Key? key, required this.searchItem})
// //       : super(key: key);

// //   final Data searchItem;

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListTile(
// //       contentPadding: const EdgeInsets.all(0),
// //       leading: ClipRRect(
// //         borderRadius: BorderRadius.circular(25),
// //         child: Container(
// //           height: 50,
// //           width: 55,
// //           // color: primaryColor,
// //           child: Image.network(
// //             '${searchItem.image}',
// //             fit: BoxFit.fill,
// //           ),
// //         ),
// //       ),
// //       title: TextInput(
// //         text1: '${searchItem.name}',
// //         weight: FontWeight.w600,
// //         size: 14,
// //         maxLines: 2,
// //       ),
// //       subtitle: TextInput(
// //         size: 12,
// //         text1: '${searchItem.sku}',
// //         colorOfText: Colors.grey,
// //       ),
// //     );
// //     // Row(
// //     //   children: [
// //     //     SizedBox(
// //     //       height: 70,
// //     //       width: 70,
// //     //       child: CircleAvatar(
// //     //         child: Image.asset("images/Layer 10.png"),
// //     //       ),
// //     //     ),
// //     //     Padding(
// //     //       padding: const EdgeInsets.all(8.0),
// //     //       child: Column(
// //     //         mainAxisAlignment: MainAxisAlignment.start,
// //     //         crossAxisAlignment: CrossAxisAlignment.start,
// //     //         children: const [
// //     //           TextInput(text1: "Addids", weight: FontWeight.bold),
// //     //           TextInput(text1: "Hoodie black/white", weight: FontWeight.bold),
// //     //           TextInput(
// //     //             size: 12,
// //     //             text1: "simpley dummy test of pricing",
// //     //             colorOfText: Colors.grey,
// //     //           )
// //     //         ],
// //     //       ),
// //     //     )
// //     //   ],
// //     // );
// //   }
// // }
