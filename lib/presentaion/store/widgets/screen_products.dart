import 'package:fazzmi/presentaion/featuredProductScreen/featuredProductScreen.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/commonMethods.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/Custom_inkWell.dart';
import '../../productDetailPage/screenProductDetailPage.dart';

class HorizontalListStore extends StatefulWidget {
  final String name;
  final String price, specialPrice, parentCategoryId;
  final String image;
  final int qty;
  final int productid;
  final String shopType;
  final String sku, storeName;
  final int storeId, salable_qty;
  final int doubleStore;
  final int wishList, wishlistProductId, index;

  final int featuredProductId;
  const HorizontalListStore({
    required this.image,
    required this.name,
    required this.price,
    required this.qty,
    required this.productid,
    Key? key,
    required this.shopType,
    required this.wishList,
    required this.featuredProductId,
    required this.sku,
    required this.storeId,
    required this.doubleStore,
    required this.specialPrice,
    required this.storeName,
    required this.wishlistProductId,
    required this.index,
    required this.parentCategoryId,
    required this.salable_qty,
  }) : super(key: key);

  @override
  State<HorizontalListStore> createState() => _HorizontalListStoreState();
}

class _HorizontalListStoreState extends State<HorizontalListStore>
    with TickerProviderStateMixin {
  @override
  dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // loadData();
  }

  // loadData() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<CartCounterStore>(context, listen: false)
  //         .getStoreProductDeatils();
  //   });
  // }

  bool favorite = true;
  bool isloaderfav = false;
  bool cartloader = false;
  String? outOfStockMsg;
  bool isStockAvailable = true;

  void changeFavorite() async {
    setState(() {
      isloaderfav = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CartCounterStore>(context, listen: false)
          .addfavorite(productId: widget.featuredProductId);
    });
    Future.delayed(
        const Duration(milliseconds: 300),
        () => setState(() {
              isloaderfav = false;
            }));
    setState(() {
      favorite = !favorite;
    });
  }

  checkStock(qty, salable_qty) {
    if (salable_qty == 0 || qty > salable_qty) {
      isStockAvailable = false;
      outOfStockMsg = (salable_qty == 0)
          ? "This Product is Out Of Stock!"
          : "You've reached the maximum limit for this product!";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sorry!!"),
            content: Text("$outOfStockMsg"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    double acctualPrice = double.parse(widget.price.replaceAll('+', ''));
    double offerPrice = double.parse(widget.specialPrice.replaceAll('+', ''));
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenProductDetail(
                          storeId: widget.storeId,
                          parentCategoryId: widget.parentCategoryId,
                          productId: widget.wishlistProductId,
                          wishList: widget.wishList == 0 ? false : true,
                          storeName: widget.storeName,
                          productName: widget.name,
                          qty: widget.qty,
                          shopType: widget.shopType,
                          sku: widget.sku,
                        )));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                fit: StackFit.passthrough,
                children: [
                  SizedBox(
                    width: widget.shopType != "1" ? 150 : 130,
                    height: widget.shopType != "1" ? 150 : 190,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('images/22_LOGIN PAGE-4.png');
                        },
                      ),
                    ),
                  ),
                  if (box.read("token") != null)
                    Consumer<CartCounterStore>(
                        builder: (context, value, child) {
                      return IconFavourite(
                        index: widget.index,
                        right: 9,
                        top: 3,
                        isSelected: widget.wishList == 0 ? false : true,
                        onFavourite: () {
                          widget.wishList == 0
                              ? value.addfavorite(
                                  favIndex: widget.index,
                                  productId: widget.wishlistProductId)
                              : value.deletefavorite(
                                  favIndex: widget.index,
                                  productId: widget.wishlistProductId);
                        },
                      );
                    }),
                  if (widget.shopType != "1")
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: InkWell(
                        onTap: () {},
                        child: Consumer<CartCounterStore>(
                            builder: (context, value, child) {
                          return AnimatedContainer(
                            height: 39,
                            width: (value.addtoCartLoader &&
                                    value.cartIndex == widget.index)
                                ? 130
                                : ((widget.qty == 0) ? 39 : 130),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xFFDDDDDD),
                                      offset: Offset(1, 1),
                                      blurRadius: .1,
                                      spreadRadius: .1,
                                      blurStyle: BlurStyle.outer),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3)),
                            duration: const Duration(milliseconds: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if ((cartloader &&
                                        value.cartIndex == widget.index) ||
                                    widget.qty != 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1),
                                    child: Row(
                                      children: [
                                        width10,

                                        /// decrement
                                        CustomInkWell(
                                            onTap: () async {
                                              value.decrementCart(
                                                  index: widget.index,
                                                  name: widget.sku,
                                                  productid: widget.productid,
                                                  qty: widget.qty);
                                            },
                                            child: SizedBox(
                                              width: 30,
                                              child: widget.qty == 1
                                                  ? const Icon(
                                                      Icons
                                                          .delete_outline_outlined,
                                                      color: primaryColor,
                                                      size: 22,
                                                    )
                                                  : Icon(
                                                      Icons.remove_rounded,
                                                      color: primaryColor,
                                                      size: 30,
                                                    ),
                                              // : SizedBox(
                                              //     width: 30,
                                              //     height: 15,
                                              //     child: Image.asset(
                                              //         "images/38_STORE_RED-MINUS-.png")),
                                            )),
                                        width10,
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 24,
                                          width: 40,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 1),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2),
                                                  child: Consumer<
                                                          CartCounterStore>(
                                                      builder: (context, value,
                                                          child) {
                                                    return (value
                                                                .addtoCartLoader &&
                                                            value.cartIndex ==
                                                                widget.index)
                                                        ? const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                          )
                                                        : TextInput(
                                                            text1:
                                                                '${widget.qty}',
                                                            colorOfText:
                                                                Colors.black,
                                                            size: 15,
                                                          );
                                                  }),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                // width5,
                                SizedBox(width: 4),
                                //// INCREMENT
                                CustomInkWell(
                                  onTap: () {
                                    print(widget.salable_qty);
                                    if (widget.salable_qty == 0 ||
                                        widget.qty > widget.salable_qty) {
                                      checkStock(
                                          widget.qty, widget.salable_qty);
                                    } else {
                                      value.addtoCart(
                                          index: widget.index,
                                          name: widget.sku,
                                          qty: widget.qty,
                                          productid: widget.productid);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: primaryColor,
                                    size: 30,
                                  ),
                                  // child: SizedBox(
                                  //     width: 30,
                                  //     height: 16,
                                  //     child: Image.asset(
                                  //         "images/38_STORE_RED-64.png")),
                                ),
                                width5
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
              height5,
              SizedBox(
                width: widget.shopType != "1" ? 150 : 130,
                child: TextInput(
                  size: 12,
                  text1: widget.name,
                  // + " | $cartloader",
                  maxLines: 2,
                ),
              ),
// offer starts here!!!!!!!!!!!!!!!
              // if (widget.price != '0' && offerPrice != 0.0)
              TextInput(
                text1: "₹ ${offerPrice == 0 ? acctualPrice : offerPrice}",
                size: 16,
                weight: FontWeight.w100,
              ),
              (offerPrice != 0 && (acctualPrice != offerPrice))
                  ? Row(
                      children: [
                        Text(
                          "₹ $acctualPrice",
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: TextInput(
                            text1: calcPercentage(acctualPrice, offerPrice),
                            colorOfText: Colors.green,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              // Padding(
              //   padding: EdgeInsets.only(
              //       top: (widget.price != '0' && offerPrice != 0.0) ? 0 : 5),
              //   child: Row(
              //     children: [
              //       TextInput(
              //         text1: "₹ $acctualPrice\t\t\t",
              //         size: widget.price != '0' && offerPrice != 0.0 ? 12 : 18,
              //         weight: offerPrice == 0.0 ? FontWeight.w100 : null,
              //         decoration: offerPrice != 0.0
              //             ? widget.price != '0'
              //                 ? TextDecoration.lineThrough
              //                 : TextDecoration.none
              //             : null,
              //       ),
              //       if (acctualPrice != 0.0 && offerPrice != 0.0)
              //         TextInput(
              //           text1: calcPercentage(acctualPrice, offerPrice),
              //           size: 12,
              //           weight: FontWeight.w600,
              //           colorOfText: Colors.green,
              //         ),
              //     ],
              //   ),
              // ),
//

              // SizedBox(
              //   width: widget.shopType != "2" ? 150 : 130,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       SizedBox(
              //           height: 20, child: Image.asset("images/delivery.png")),
              //       const TextInput(
              //         size: 10,
              //         text1: "Arrives",
              //       ),
              //       const TextInput(
              //         size: 11,
              //         text1: "TOMORROW",
              //         colorOfText: Colors.green,
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ));
  }

  Widget _buildIcon(
      {required double size,
      color,
      required double top,
      required double right,
      void Function()? function}) {
    return Positioned(
      top: top,
      right: right,
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: function,
          icon: Icon(
            Icons.favorite,
            color: color,
            size: size,
          ),
        ),
      ),
    );
  }

  // calcPercentage(price, offerP) {
  //   var percentage = ((price - offerP) / price) * 100;
  //   if (percentage.isNaN) {
  //     return '';
  //   } else {
  //     return '${percentage.toInt()}% OFF';
  //   }
  // }
}
