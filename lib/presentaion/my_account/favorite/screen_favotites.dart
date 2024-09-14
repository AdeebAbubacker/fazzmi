// import 'package:fazzmi/provider/cartInStore.dart';
// import 'package:fazzmi/widgets/textInput.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../core/constans/constants.dart';
// import '../product_detail_2/screenProductDetailPage.dart';

// class Wishlist extends StatefulWidget {
//   final String name;
//   final String price;
//   final String image;
//   final int qty, storeId;
//   final String sku, parentCategoryId;
//   final int productid;
//   final String shopType;

//   const Wishlist({
//     required this.image,
//     required this.name,
//     required this.price,
//     required this.qty,
//     required this.productid,
//     Key? key,
//     required this.sku,
//     required this.shopType,
//     required this.parentCategoryId,
//     required this.storeId,
//   }) : super(key: key);

//   @override
//   State<Wishlist> createState() => _WishlistState();
// }

// class _WishlistState extends State<Wishlist> with TickerProviderStateMixin {
//   @override
//   dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   loadData() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CartCounterStore>(context, listen: false)
//           .getStoreProductDeatils();
//     });
//   }

//   bool favorite = true;
//   // void changeFavorite() {
//   //   favorite = !favorite;
//   //   setState(() {});
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ScreenProductDetail(
//                     storeId: widget.storeId,
//                     parentCategoryId: widget.parentCategoryId,
//                     productId: widget.productid,
//                     wishList: favorite,
//                     storeName: widget.name,
//                     shopType: widget.shopType,
//                     productName: widget.name,
//                     sku: widget.sku,
//                     qty: widget.qty)));
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Stack(
//             fit: StackFit.passthrough,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(10)),
//                 width: MediaQuery.of(context).size.width / 2.3,
//                 height: MediaQuery.of(context).size.width / 2.3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       widget.image,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               _buildIcon(
//                   function: () {},
//                   color: favorite ? Colors.white70 : primaryColor,
//                   size: 32,
//                   top: -7,
//                   right: -7),
//               Consumer<CartCounterStore>(builder: (context, value, child) {
//                 return _buildIcon(
//                     color: favorite ? Colors.white : primaryColor,
//                     function: () async {
//                       var response;
//                       if (favorite) {
//                         // changeFavorite();
//                         value.addfavorite(productId: widget.productid);
//                         response = await value.addfavorite(
//                             productId: widget.productid);
//                       } else {
//                         // changeFavorite();
//                         value.deletefavorite(productId: response);
//                       }
//                     },
//                     size: 28,
//                     top: -7,
//                     right: -7);
//               }),
//               Positioned(
//                   bottom: 10,
//                   right: 7,
//                   child: InkWell(
//                       onTap: () {},
//                       child: Consumer<CartCounterStore>(
//                           builder: (context, value, child) {
//                         return AnimatedContainer(
//                           height: 42,
//                           width: (widget.qty == 0)
//                               ? 50
//                               : MediaQuery.of(context).size.width / 2.5,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           duration: const Duration(milliseconds: 1),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               if (widget.qty != 0)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 2),
//                                   child: Row(
//                                     children: [
//                                       width20,

//                                       //// decrement
//                                       InkWell(
//                                           onTap: () {
//                                             value.decrementCart(
//                                                 name: widget.name,
//                                                 productid: widget.productid,
//                                                 qty: widget.qty);
//                                           },
//                                           child: const SizedBox(
//                                             child: TextInput(
//                                               text1: "-",
//                                               colorOfText: primaryColor,
//                                               size: 28,
//                                             ),
//                                           )),
//                                       width20,

//                                       Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         height: 35,
//                                         width: 40,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(2),
//                                           child: Center(
//                                             child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     bottom: 4),
//                                                 child: TextInput(
//                                                   text1: '${widget.qty}',
//                                                   colorOfText: Colors.black,
//                                                   size: 23,
//                                                 )),
//                                           ),
//                                         ),
//                                       ),
//                                       width10,
//                                     ],
//                                   ),
//                                 ),

//                               //// INCREMENT
//                               InkWell(
//                                 onTap: () {
//                                   value.addtoCart(
//                                       name: widget.name,
//                                       qty: widget.qty,
//                                       productid: widget.productid);
//                                 },
//                                 child: SizedBox(
//                                     width: 40,
//                                     height: 15,
//                                     child: Image.asset(
//                                         "images/38_STORE_RED-64.png")),
//                               ),
//                             ],
//                           ),
//                         );
//                       }))),
//             ],
//           ),
//           height5,
//           Padding(
//             padding: const EdgeInsets.only(left: 15, right: 15),
//             child: Column(
//               children: [
//                 Align(
//                     alignment: Alignment.topLeft,
//                     child: TextInput(
//                       size: 13,
//                       text1: widget.name,
//                       weight: FontWeight.bold,
//                     )),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 3),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: TextInput(text1: "₹${widget.price}")),
//                 ),
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                           height: 25,
//                           width: 25,
//                           child:
//                               Image.asset("images/28_PRODUCT DETAIL 2-60.png")),
//                       const TextInput(
//                         size: 13,
//                         text1: "Arrives",
//                       ),
//                       const TextInput(
//                         size: 13,
//                         text1: "TOMORROW",
//                         colorOfText: Colors.green,
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIcon(
//       {required double size,
//       color,
//       required double top,
//       required double right,
//       void Function()? function}) {
//     return Positioned(
//       top: top,
//       right: right,
//       child: Container(
//         height: 48,
//         width: 48,
//         alignment: Alignment.center,
//         child: IconButton(
//           onPressed: function,
//           icon: Icon(
//             Icons.favorite,
//             color: color,
//             size: size,
//           ),
//         ),
//       ),
//     );
//   }
// }
