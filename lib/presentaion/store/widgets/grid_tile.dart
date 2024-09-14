// import 'package:flutter/material.dart';
// import 'package:flutter/src/animation/animation_controller.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter/src/widgets/ticker_provider.dart';

// class GridTileWidget extends StatefulWidget {
//   const GridTileWidget({super.key});

//   @override
//   State<GridTileWidget> createState() => _GridTileWidgetState();
// }

// class _GridTileWidgetState extends State<GridTileWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       if (widget.shopType != "1")
//        Positioned(
//                         bottom: 12,
//                         right: 12,
//                         child: InkWell(
//                             onTap: () {},
//                             child: Consumer<CartCounterStore>(
//                                 builder: (context, value, child) {
//                               return AnimatedContainer(
//                                 height: 35,
//                                 width: (productBoxCartLoader &&
//                                         value.cartIndex == widget.index)
//                                     ? 130
//                                     : ((widget.qty == 0) ? 35 : 130),
//                                 decoration: BoxDecoration(
//                                     boxShadow: const [
//                                       BoxShadow(
//                                           color: Color(0xFFDDDDDD),
//                                           offset: Offset(1, 1),
//                                           blurRadius: .1,
//                                           spreadRadius: .1,
//                                           blurStyle: BlurStyle.outer),
//                                     ],
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(3)),
//                                 duration: const Duration(milliseconds: 1),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     if ((productBoxCartLoader &&
//                                             value.cartIndex == widget.index) ||
//                                         widget.qty != 0)
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 1),
//                                         child: Row(
//                                           children: [
//                                             width10,

//                                             /// decrement
//                                             CustomInkWell(
//                                                 onTap: () async {
//                                                   productBoxCartLoader = true;

//                                                   value.decrementCart(
//                                                       index: widget.index,
//                                                       name: widget.sku,
//                                                       productid:
//                                                           widget.productid,
//                                                       qty: widget.qty);

//                                                   productBoxCartLoader = false;
//                                                 },
//                                                 child: SizedBox(
//                                                   child: widget.qty == 1
//                                                       ? const Icon(
//                                                           Icons
//                                                               .delete_outline_outlined,
//                                                           size: 22,
//                                                         )
//                                                       : SizedBox(
//                                                           width: 30,
//                                                           height: 15,
//                                                           child: Image.asset(
//                                                               "images/38_STORE_RED-MINUS-.png")),
//                                                 )),
//                                             width10,
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10)),
//                                               height: 24,
//                                               width: 40,
//                                               child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           bottom: 1),
//                                                   child: Center(
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               bottom: 2),
//                                                       child: Consumer<
//                                                               CartCounterStore>(
//                                                           builder: (context,
//                                                               value, child) {
//                                                         return (productBoxCartLoader &&
//                                                                 value.cartIndex ==
//                                                                     widget
//                                                                         .index)
//                                                             ? const SizedBox(
//                                                                 height: 20,
//                                                                 width: 20,
//                                                                 child:
//                                                                     CircularProgressIndicator(
//                                                                   strokeWidth:
//                                                                       2,
//                                                                 ),
//                                                               )
//                                                             : TextInput(
//                                                                 text1:
//                                                                     '${widget.qty}',
//                                                                 colorOfText:
//                                                                     Colors
//                                                                         .black,
//                                                                 size: 15,
//                                                               );
//                                                       }),
//                                                     ),
//                                                   )),
//                                             ),
//                                             width5,
//                                           ],
//                                         ),
//                                       ),
//                                     //// INCREMENT
//                                     CustomInkWell(
//                                       onTap: () {
//                                         productBoxCartLoader = true;

//                                         // bool stock =
//                                         checkStock(
//                                             widget.qty, widget.salable_qty);

//                                         // if (!stock) {
//                                         //   productBoxCartLoader = false;
//                                         //   return;
//                                         // }

//                                         if (
//                                             // checkStock(widget.qty,
//                                             //       widget.salable_qty) &&
//                                             widget.doubleStore == 0) {
//                                           value.addtoCart(
//                                               index: widget.index,
//                                               name: widget.sku,
//                                               qty: widget.qty,
//                                               productid: widget.productid);
//                                         }

//                                         productBoxCartLoader = false;
//                                       },
//                                       child: SizedBox(
//                                           width: 30,
//                                           height: 15,
//                                           child: Image.asset(
//                                               "images/38_STORE_RED-64.png")),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }))),
//     );
//   }
// }