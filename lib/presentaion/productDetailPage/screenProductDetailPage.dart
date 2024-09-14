import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/model/GuestCartResponsemodell/guestCart_response_model.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/constants/commonMethods.dart';
import '../../model/cartproductlist/cart_product_list.dart';
import '../../provider/ProductDetailPageProviderApi.dart';
import '../../provider/timerProvider.dart';
import '../../widgets/textInput.dart';
import '../shopping_folder/screen_shopping_basket.dart';
import '../store/screen_stores.dart';
import '../store/widgets/alert/alertWidget.dart';

class ScreenProductDetail extends StatefulWidget {
  ScreenProductDetail({
    Key? key,
    required this.sku,
    required this.qty,
    required this.productName,
    required this.shopType,
    required this.storeName,
    required this.wishList,
    required this.productId,
    required this.parentCategoryId,
    required this.storeId,
  }) : super(key: key);

  int qty;
  final bool wishList;
  final int productId, storeId;

  final String productName, shopType, sku, storeName, parentCategoryId;

  @override
  State<ScreenProductDetail> createState() => _ScreenProductDetail2State();
}

class _ScreenProductDetail2State extends State<ScreenProductDetail>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // final DynamicLinks _dynamicLinkService =  DynamicLinks();

  // final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  late Timer _timerLink;
  late TabController _controller;
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  var cartValue = 0;
  final _controllerForDecrementIncrement = TextEditingController(text: "1");
  var box = GetStorage();
  @override
  void initState() {
    loadCartfunction();
    // fncLoading();

    Provider.of<ProductDetailPageProviderApi>(context, listen: false)
        .changeColor(value: 0);
    Provider.of<ProductDetailPageProviderApi>(context, listen: false)
        .changeSize(value: 0);
    Provider.of<ProductDetailPageProviderApi>(context, listen: false)
        .startTimer();
    loadData(color: colorValue, size: sizeValue);
    DynamicLinks.instance.initDynamicLink(context);

    scrollController.addListener(() {
      double showoffset = 10.0;
      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {});
      } else {
        showbtn = false;
        setState(() {});
      }
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controllerForDecrementIncrement.text = "1";
    _controller = TabController(length: 2, vsync: this);
  }

  loadCartfunction() async {
    if (box.read("token") != null) {
      ViewCartPageModel? loginCartResult =
          await Provider.of<CartCounterStore>(context, listen: false)
              .getCartProductDetailsLogin();
      checkStoreCart(loginCartResult);

      var isCart =
          loginCartResult!.items!.where((ele) => ele.sku == widget.sku);
      if (isCart.isNotEmpty) {
        qntity =
            isCart.first.qty == 0 ? (isCart.first.qty! + 1) : isCart.first.qty!;
        firstqty =
            isCart.first.qty == 0 ? (isCart.first.qty! + 1) : isCart.first.qty!;
      }
    } else {
      GuestCartResponsemodel? guestCartResult =
          await Provider.of<CartCounterStore>(context, listen: false)
              .getCartProductDetailsGuest();
      checkStoreCart(guestCartResult);

      var isCart =
          guestCartResult!.items!.where((ele) => ele.sku == widget.sku);

      if (isCart.isNotEmpty) {
        qntity = isCart.first.qty!;
        firstqty = isCart.first.qty!;
      }
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _timerLink = new Timer(
  //       const Duration(milliseconds: 1000),
  //       () {
  //         // _dynamicLinkService.retrieveDynamicLink(context);
  //       },
  //     );
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  loadData({color, size, selection}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var pDetails = await Provider.of<ProductDetailPageProviderApi>(context,
              listen: false)
          .getProductDetails(
              color: color, size: size, sku: widget.sku, selection: selection);

      await Provider.of<TimerProvider>(context, listen: false).startTimer(
          date: pDetails!.data!.productInfo!.deliveryDate!,
          hours: pDetails.data!.productInfo!.cutoffTime!);
      await Provider.of<CartCounterStore>(context, listen: false).getWishList();
    });
  }

  // fncLoading() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Provider.of<CartCounterStore>(context, listen: false).changeMode();
  //   });
  // }

  checkStoreCart(cartItem) async {
    if (cartItem!.items!.isNotEmpty) {
      if (cartItem.items![0].extensionAttributes!.store ==
          '${widget.storeId}') {
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertAndroidWidget(
                title: const Text("Start a new basket?"),
                content: Text(
                    "Your basket contains items from '${cartItem!.items![0].extensionAttributes!.store_name!}.' Do you want to clear the cart  and shop from ${widget.storeName}?"),
                onCancelchild: const Text("Cancel"),
                submitchild: const Text("Start"),
                onCancelAction: () {
                  Navigator.of(context).pop();
                  // Navigator.pop(context);
                },
                submitAction: () async {
                  var res = await Provider.of<CartCounterStore>(context,
                          listen: false)
                      .clearCart();
                  Navigator.of(context).pop();
                },
              );
            });
      }
    }
  }

  checkStock(qty, salableqty) async {
    if (qty > salableqty) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertAndroidWidget(
              content: const Text("Stock Unavailable"),
              onCancelchild: const Text("Cancel"),
              submitchild: const Text("Continue..."),
              onCancelAction: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              submitAction: () async {
                setState(() {
                  qntity--;
                });
                // var res =
                //     await Provider.of<CartCounterStore>(context, listen: false)
                //         .clearCart();
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  Future<bool> _onWillPop() async {
    return await Provider.of<TimerProvider>(context, listen: false).onWillPop();
  }

  _buildAppBar({icon, title, action, backPress}) {
    return AppBar(
      leading: IconButton(
          onPressed: backPress,
          icon: Icon(
            icon,
            color: Colors.grey,
            size: 20,
          )),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Poppins'),
      ),
      centerTitle: true,
      actions: action,
      elevation: 0,
    );
  }

  /// SET OF IMAGES
  Widget indicator(index, image) {
    return AnimatedSmoothIndicator(
      effect: const SlideEffect(
          spacing: 15.0,
          radius: 50.0,
          dotWidth: 8.0,
          dotHeight: 8.0,
          paintStyle: PaintingStyle.stroke,
          strokeWidth: 1.5,
          dotColor: Colors.grey,
          activeDotColor: primaryColor),
      activeIndex: index,
      count: image,
    );
  }

  int qntity = 0;
  int firstqty = 0;
  int index = 0;
  int colorValue = 0;
  int sizeValue = 0;

  movingCard(image, imagelengh) {
    return CarouselSlider(
        items: List.generate(
          imagelengh,
          (index) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
        options: CarouselOptions(
          height: 500,
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          onPageChanged: (value, _) {
            setState(() {
              index = value;
            });
          },
          scrollDirection: Axis.horizontal,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var primaryQty = widget.qty;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(
            title: widget.productName,
            icon: Icons.arrow_back_ios,
            backPress: () {
              // SchedulerBinding.instance.addPostFrameCallback((_) {
              // _onWillPop();
              Navigator.pop(context);
              // });
            }),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SET OF IMAGE BANNER UI
                    _buildImageBanner(),
                    height10,

                    /// name
                    _buildProductName(),

                    /// price and specil price
                    _buildPriceAndSpecialPrice(),
                    height10,

                    /// variations

                    _buildVariations(),

                    /// cut of time section

                    // _buildCutOfTimeForFashion(),

                    height5,

                    _buildCutOfTimeForGroceryProducts(),
                    _buildTextContainer(),
                    _buildSoldContainer(context),

                    /// overView And Specifications
                    _buildOverviewAndSpecifications()
                  ],
                ),
              ),
            ),

            ////  BUTTON FOR ADD TO CART

            Consumer<ProductDetailPageProviderApi>(
                builder: (context, productDetailValue, child) {
              if (!productDetailValue.loader) {
                var productData =
                    productDetailValue.productDetailList!.data!.productInfo;

                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: productData!.available! == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (qntity > 1) {
                                          qntity--;
                                        }
                                      });
                                    },
                                    child: ImageContainer(
                                      colors: Colors.grey,
                                      imageName:
                                          Image.asset("images/-button.png"),
                                    ),
                                  ),
                                  width10,
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 30,
                                      child: Consumer<CartCounterStore>(
                                          builder: (context, value, child) {
                                        if (!value.loader) {
                                          return Center(
                                            child: TextInput(
                                              text1: qntity == 0
                                                  ? (qntity + 1).toString()
                                                  : (qntity).toString(),
                                              size: 21,
                                            ),
                                          );
                                        } else {
                                          return const SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                            ),
                                          );
                                        }
                                      }),
                                    ),
                                  ),
                                  width5,
                                  InkWell(
                                    onTap: () {
                                      print(productData.salable_qty);
                                      setState(() {
                                        if (qntity == 0) {
                                          qntity = qntity + 2;
                                        } else {
                                          qntity++;
                                        }
                                        checkStock(
                                            qntity, productData.salable_qty);
                                      });
                                    },
                                    child: ImageContainer(
                                      colors: Colors.green.shade100,
                                      imageName:
                                          Image.asset("images/+button.png"),
                                    ),
                                  ),
                                ],
                              ),
                              Consumer<CartCounterStore>(
                                  builder: (context, value, child) {
                                var itemid;
                                if (firstqty != 0) {
                                  if (box.read("quoteIdLogin") != null) {
                                    var isCart = value.productDetailList!.items!
                                        .where((ele) => ele.sku == widget.sku);
                                    if (isCart.isNotEmpty) {
                                      itemid = isCart.first.itemId!;
                                    }
                                  } else if (box.read("quoteIdGuest") != null) {
                                    var isCart = value.guestCartList!.items!
                                        .where((ele) => ele.sku == widget.sku);
                                    if (isCart.isNotEmpty) {
                                      itemid = isCart.first.itemId!;
                                    }
                                  }
                                }
                                var result;

                                return Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: primaryColor),
                                          onPressed: () async {
                                            result = await value.addtoCart(
                                                profuctfromDetailPage: true,
                                                colorId: productDetailValue
                                                    .valueColor,
                                                colorOprionId:
                                                    productDetailValue
                                                        .optionColor,
                                                index: 0,
                                                name: productDetailValue.sku,
                                                primaryqty: firstqty,
                                                productType: productDetailValue
                                                    .productType,
                                                productid: itemid,
                                                qty: qntity,
                                                sizeId: productDetailValue
                                                    .valueSize,
                                                sizeOptionId: productDetailValue
                                                    .optionSize);

                                            // value.setAddtoCartLoader(false);

                                            // if (box.read("quoteIdGuest") !=
                                            //     null) {
                                            //   await value.addProductCartGuest(
                                            //       primaryqty: primaryQty + 1,
                                            //       colorOprionId:
                                            //           productDetailValue
                                            //               .optionColor,
                                            //       sizeOptionId:
                                            //           productDetailValue
                                            //               .optionSize,
                                            //       colorId: productDetailValue
                                            //           .valueColor,
                                            //       sizeId: productDetailValue
                                            //           .valueSize,
                                            //       productType:
                                            //           productDetailValue
                                            //               .productType,
                                            //       sku: productDetailValue.sku,
                                            //       qty: (widget.qty > firstqty)
                                            //           ? widget.qty - firstqty
                                            //           : widget.qty);
                                            // }
                                            // if (box.read("quoteIdLogin") !=
                                            //     null) {
                                            //   await value.addProductCartLogin(
                                            //       primaryqty: primaryQty,
                                            //       colorOprionId:
                                            //           productDetailValue
                                            //               .optionColor,
                                            //       sizeOptionId:
                                            //           productDetailValue
                                            //               .optionSize,
                                            //       colorId: productDetailValue
                                            //           .valueColor,
                                            //       sizeId: productDetailValue
                                            //           .valueSize,
                                            //       productType:
                                            //           productDetailValue
                                            //               .productType,
                                            //       sku: productDetailValue.sku,
                                            //       qty: (widget.qty > firstqty)
                                            //           ? widget.qty - firstqty
                                            //           : widget.qty);
                                            // }

                                            // if (value.addtoCartLoader ==
                                            //     false) {

                                            if (result == true) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ScreenShoppingBasket(
                                                            storeName: widget
                                                                .storeName,
                                                          )));
                                            }

                                            // var data = Timer.periodic(
                                            //     const Duration(seconds: 2),
                                            //     (_) =>

                                            // );
                                          },
                                          child: (value.loader)
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : const TextInput(
                                                  text1: "ADD TO CART")),
                                    ),
                                  ],
                                );
                              })
                            ],
                          )
                        : const Center(
                            child: TextInput(
                            text1: "UNAVAILABLE",
                            colorOfText: primaryColor,
                          )),
                  ),
                  color: Colors.blue[50],
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                );
              } else {
                return const SizedBox();
              }
            })
          ],
        ),
        // floatingActionButton: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: AnimatedOpacity(
        //           duration: const Duration(milliseconds: 1000),
        //           opacity: showbtn ? 1.0 : 0.0,
        //           child: Container(
        //             decoration: BoxDecoration(
        //                 color: Colors.black,
        //                 borderRadius: BorderRadius.circular(20)),
        //             width: 130.0,
        //             height: 30.0,
        //             child: RawMaterialButton(
        //               elevation: 0.0,
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: const [
        //                   Icon(
        //                     Icons.arrow_upward,
        //                     color: Colors.white,
        //                     size: 18,
        //                   ),
        //                   width5,
        //                   TextInput(
        //                     text1: "BACK TO TOP",
        //                     size: 10,
        //                     colorOfText: Colors.white,
        //                   )
        //                 ],
        //               ),
        //               onPressed: () {
        //                 scrollController.animateTo(0,
        //                     duration: const Duration(milliseconds: 500),
        //                     curve: Curves.fastOutSlowIn);
        //               },
        //             ),
        //           )),
        //     ),
        //     height40,
        //     height10
        //   ],
        // ),
      ),
    );
  }

  Padding _buildTextContainer() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          SizedBox(
            height: 15,
            width: 20,
            child: Image.asset("images/no-return.png"),
          ),
          width10,
          const TextInput(
            text1: "This item cannot be exchanged or returned",
            colorOfText: Colors.grey,
          )
        ],
      ),
    );
  }

  Container _buildSoldContainer(BuildContext context) {
    return Container(
      height: 40,
      color: Color.fromARGB(255, 247, 250, 250),
      // color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "images/28_PRODUCT DETAIL 2-32.png",
                  height: 20,
                  width: 20,
                ),
                width10,
                Row(
                  children: [
                    const TextInput(
                      text1: "Sold by",
                    ),
                    width10,
                    Row(
                      children: [
                        TextInput(
                          text1: widget.storeName,
                          colorOfText: Colors.green,
                        ),
                        // const TextInput(
                        //   text1: "Store",
                        //   colorOfText: Colors.green,
                        // ),
                      ],
                    )
                  ],
                )
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScreenStores(
                                parentCategoryId: widget.parentCategoryId,
                                shoptype: (widget.storeId == "simple") ? 2 : 1,
                                storeId: widget.storeId,
                                storename: widget.storeName,
                              )));
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 15,
                ))
          ],
        ),
      ),
    );
  }

  Consumer<ProductDetailPageProviderApi> _buildOverviewAndSpecifications() {
    return Consumer<ProductDetailPageProviderApi>(
        builder: (context, value, child) {
      if (!value.loader) {
        return SingleChildScrollView(
          child: Column(
            children: [
              TabBar(
                  indicatorColor: primaryColor,
                  labelColor: primaryColor,
                  controller: _controller,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      child: TextInput(
                        text1: "Overview",
                      ),
                    ),
                    Tab(
                      child: TextInput(
                        text1: "Specifications",
                      ),
                    )
                  ]),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(controller: _controller, children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Html(
                          data: value.description ?? "OverView",
                          style: {
                            'h1': Style(color: Colors.red),
                            'p': Style(
                                color: Colors.black87,
                                fontSize: FontSize.medium),
                            'ul': Style(margin: Margins.symmetric(vertical: 20))
                          },
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Html(
                          data: value.shortDescription ?? "specification",
                          style: {
                            'h1': Style(color: Colors.red),
                            'p': Style(
                                color: Colors.black87,
                                fontSize: FontSize.medium),
                            'ul': Style(margin: Margins.symmetric(vertical: 20))
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Consumer<ProductDetailPageProviderApi> _buildCutOfTimeForGroceryProducts() {
    return Consumer<ProductDetailPageProviderApi>(
        builder: (context, value, child) {
      if (!value.loader) {
        return Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 247, 250, 250)),
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "images/28_PRODUCT DETAIL 2-60.png",
                          height: 20,
                        ),
                      ),
                    ),
                    width10,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextInput(
                          text1: "Order in the next",
                          size: 14,
                          colorOfText: Colors.grey,
                        ),
                        // Cut Of Time

                        Consumer<TimerProvider>(
                          builder: (context, value, child) {
                            final hours =
                                value.twoDigits(value.duration.inHours);
                            final minutes = value.twoDigits(
                                value.duration.inMinutes.remainder(60));
                            final seconds = value.twoDigits(
                                value.duration.inSeconds.remainder(60));
                            return TextInput(
                              text1: '$hours:$minutes:$seconds',
                              size: 13,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextInput(
                        text1: "Delivery Date",
                        size: 13,
                        colorOfText: Colors.grey.shade800),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextInput(
                                  textAlign: TextAlign.center,
                                  text1:
                                      "${Provider.of<TimerProvider>(context).tomWeekDay()}\n${Provider.of<TimerProvider>(context).tomDate()}",
                                  colorOfText: primaryColor,
                                  size: 12,
                                )
                              ]),
                        ),
                        Container(
                          width: 90,
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Color.fromARGB(255, 227, 220, 220),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                TextInput(
                                  text1: "11AM-3PM",
                                  size: 12,
                                )
                              ]),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          color: Colors.grey[0],
        );
      } else {
        return const SizedBox();
      }
    });
  }

  SizedBox _buildCutOfTimeForFashion() {
    return SizedBox(
      child: Consumer<ProductDetailPageProviderApi>(
          builder: (context, value, child) {
        if (!value.loader) {
          var monthIndex = Provider.of<TimerProvider>(context).defDate!.month;
          var weekDayIndex =
              Provider.of<TimerProvider>(context).defDate!.weekday;
          var month =
              Provider.of<TimerProvider>(context).months[monthIndex - 1];
          var weekday = Provider.of<TimerProvider>(context).weeks[weekDayIndex];
          return Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const TextInput(
                            text1: "Free delivery by ",
                            colorOfText: Colors.grey,
                            weight: FontWeight.bold,
                          ),
                          TextInput(
                            text1: "$weekday,",
                            colorOfText: Colors.yellow.shade800,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          TextInput(
                            text1: "$month",
                            colorOfText: Colors.yellow.shade800,
                            size: 12,
                          ),
                          TextInput(
                            text1:
                                " ${Provider.of<TimerProvider>(context).tomDate()}",
                            colorOfText: Colors.yellow.shade800,
                            size: 12,
                          ),
                        ],
                      ),
                      const TextInput(
                        text1: "Order in 17m 13m",
                        colorOfText: Colors.grey,
                        size: 12,
                      )
                    ],
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 245, 224, 193),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, left: 13, right: 15, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextInput(
                              text1: "Want it Tommorrow?",
                              colorOfText: Colors.yellow.shade800,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const TextInput(
                          text1: "Select Get It Tommarow",
                          colorOfText: Colors.grey,
                          size: 12,
                        ),
                        const TextInput(
                          text1: "on checkout within the",
                          colorOfText: Colors.grey,
                          size: 12,
                        ),
                        const TextInput(
                          text1: "next 4 hrs and 17 mins",
                          colorOfText: Colors.grey,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(
            child: SizedBox(),
          );
        }
      }),
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

  Consumer<ProductDetailPageProviderApi> _buildVariations() {
    return Consumer<ProductDetailPageProviderApi>(
        builder: (context, value, child) {
      if (!value.loader) {
        var data = value.productDetailList!.data!.productInfo!.variations!;

        return Column(
            children: List.generate(
                data.length,
                (index) => Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextInput(
                                text1: data[index].title!,
                                weight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: index == 0 ? 180 : 75,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data[index].content!.length,
                                itemBuilder: (_, indexx) {
                                  var url =
                                      "https://staging.fazzmi.com/pub/media/catalog/product/";
                                  var actualImage;

                                  if (data[index].content![indexx].image !=
                                      null) {
                                    var image =
                                        data[index].content![indexx].image!;

                                    actualImage = url + image;
                                  } else {
                                    actualImage =
                                        "https://staging.fazzmi.com/pub/media/logo/default/22_LOGIN_PAGE-4.png";
                                  }

                                  return data[index].title == "Color"
                                      ? InkWell(
                                          onTap: () {
                                            value.changeColor(
                                                value: int.parse(data[index]
                                                    .content![indexx]
                                                    .id!));
                                            value.changeOptionColor(
                                                value: data[index].attributeId);
                                            loadData(
                                                selection: data[index].reqParam,
                                                color: int.parse(data[index]
                                                    .content![indexx]
                                                    .id!),
                                                size: value.valueSize);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color: int.parse(data[
                                                                          index]
                                                                      .content![
                                                                          indexx]
                                                                      .id!) ==
                                                                  value
                                                                      .valueColor
                                                              ? (data[index].content![indexx].available ==
                                                                          false &&
                                                                      data[index]
                                                                              .reqParam !=
                                                                          value
                                                                              .selections)
                                                                  ? Colors.red
                                                                  : Colors.blue
                                                              : borderColor)),
                                                  height: 120,
                                                  width: 70,
                                                  child: Image.network(
                                                      actualImage
                                                      // data[index]
                                                      //     .content![indexx]
                                                      //     .image!
                                                      ,
                                                      fit: BoxFit.fill),
                                                ),
                                                // TextInput(
                                                //     text1: data[index]
                                                //         .content![indexx]
                                                //         .reqVal!),
                                                // (data[index]
                                                //                 .content![
                                                //                     indexx]
                                                //                 .available ==
                                                //             false &&
                                                //         data[index].reqParam !=
                                                //             value.selections)
                                                //     ? const TextInput(
                                                //         size: 10,
                                                //         colorOfText:
                                                //             Colors.grey,
                                                //         text1: "Unavailable")
                                                //     : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            value.changeSize(
                                                value: int.parse(data[index]
                                                    .content![indexx]
                                                    .id!));
                                            value.changeOptionSize(
                                                value: data[index].attributeId);
                                            loadData(
                                                selection: data[index].title,
                                                color: value.valueColor,
                                                size: int.parse(data[index]
                                                    .content![indexx]
                                                    .id!));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 42,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: value.valueSize ==
                                                                  int.parse(data[
                                                                          index]
                                                                      .content![
                                                                          indexx]
                                                                      .id!)
                                                              ? (data[index].content![indexx].available ==
                                                                          false &&
                                                                      data[index]
                                                                              .reqParam !=
                                                                          value
                                                                              .selections)
                                                                  ? Colors.red
                                                                  : Colors.blue
                                                              : borderColor)),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              right: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          // index ==
                                                          //         0
                                                          //     ? const Padding(
                                                          //         padding: EdgeInsets.only(right: 10),
                                                          //         child: Icon(Icons.countertops),
                                                          //       )
                                                          //     : const SizedBox(),
                                                          TextInput(
                                                              text1: data[index]
                                                                  .content![
                                                                      indexx]
                                                                  .reqVal!)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // (data[index]
                                                //                 .content![
                                                //                     indexx]
                                                //                 .available ==
                                                //             false &&
                                                //         data[index].reqParam !=
                                                //             value.selections)
                                                //     ? const TextInput(
                                                //         size: 9,
                                                //         colorOfText:
                                                //             Colors.grey,
                                                //         text1: "Unavailable")
                                                //     : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                }),
                          ),
                        ),
                      ],
                    )));
      } else {
        return const SizedBox();
      }
    });
  }

  Padding _buildPriceAndSpecialPrice() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Consumer<ProductDetailPageProviderApi>(
          builder: (context, value, child) {
        if (!value.loader) {
          var data = value.productDetailList!.data!.productInfo!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextInput(
                    text1:
                        "₹ ${data.specialPrice != 0 ? data.specialPrice : data.price!}",
                    colorOfText: Colors.black,
                    weight: FontWeight.w500,
                    size: 20,
                  ),
                  width10,
                  (data.specialPrice != 0 && (data.price != data.specialPrice))
                      ? Row(
                          children: [
                            Text(
                              "₹ ${data.price}",
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextInput(
                                text1: calcPercentage(
                                    data.price, data.specialPrice!),
                                colorOfText: Colors.green,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  width10,
                ],
              ),
              const TextInput(
                text1: "(Inclusive of VAT)",
                colorOfText: Colors.grey,
              ),
              (data.quantityAndStockStatus!.isInStock == true &&
                      data.salable_qty < 11)
                  ? TextInput(
                      text1: "Low stock : only ${data.salable_qty!} left",
                      colorOfText: Colors.grey,
                      size: 12,
                    )
                  : const SizedBox(),
            ],
          );
        } else {
          return const SizedBox(
            height: 20,
          );
        }
      }),
    );
  }

  Padding _buildProductName() {
   return Padding(
  padding: const EdgeInsets.only(left: 12),
  child: Consumer<ProductDetailPageProviderApi>(
    builder: (context, value, child) {
      if (value.loader) {
        // If data is still loading, display a circular progress indicator
        return CircularProgressIndicator();
      }

      // Check if the productInfo data is available before accessing it
      var productInfo = value.productDetailList?.data?.productInfo;
      if (productInfo != null) {
        var productName = productInfo.name?.trim() ?? widget.productName.trim();
        var productSubTitle = productInfo.sub_title?.trim() ?? "";

        if (productSubTitle != "" && productSubTitle != productName) {
          productName = "$productName / $productSubTitle";
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... Your existing code for displaying product details
            // Example:
            TextInput(
              maxLines: 2,
              text1: productInfo.brand.toString() == "false" ? "" : productInfo.brand,
              colorOfText: primaryColor,
              size: 18,
            ),
            Row(
              children: [
                Expanded(
                  child: TextInput(
                    maxLines: 2,
                    text1: productName,
                    colorOfText: Colors.black,
                    size: 16,
                    ),
                  ),
                ],
              ),
              value.productDetailList!.data!.productInfo!.item_weight
                          .toString() ==
                      "false"
                  ? const SizedBox()
                  : Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          child: TextInput(
                            maxLines: 2,
                            text1: value.productDetailList!.data!.productInfo!
                                .item_weight,
                            colorOfText: primaryColor,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  Padding _buildImageBanner() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductDetailPageProviderApi>(
            builder: (context, value, child) {
          if (!value.loader) {
            bool configurableOrNot = value.productDetailList!.data!.productInfo!
                        .product_type_fazzmi ==
                    "Fashion"
                ? false
                : true;
            var imagelength = 1;
            String? result1 = "images/22_LOGIN PAGE-4.png";
            if (value.productDetailList!.data!.productInfo!.mediaGallery!
                .images!.isNotEmpty) {
              result1 = baseUrlImage +
                  value.productDetailList!.data!.productInfo!.mediaGallery!
                      .images![index].file!;
              imagelength = value.productDetailList!.data!.productInfo!
                  .mediaGallery!.images!.length;
            }
            return Stack(
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: !configurableOrNot ? 500 : 350,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: movingCard(result1, imagelength)),
                ),
                imagelength > 1
                    ? Positioned(
                        bottom: 20,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: indicator(index, imagelength),
                        ),
                      )
                    : const SizedBox(),
                Positioned(
                    right: 20,
                    top: 20,
                    child:
                        //  FutureBuilder<Uri>(

                        //     builder: (context, snapshot) {
                        //       if (snapshot.hasData) {
                        //         Uri uri = snapshot.data!;
                        //         return
                        InkWell(
                      onTap: () async {
                        await DynamicLinks.instance
                            .createDynamicLink(widget.productName, widget.qty,
                                widget.sku, widget.shopType, widget.storeName)
                            .catchError((error) {
                          const SnackBar(
                            content: TextInput(text1: "Something went wrong"),
                          );
                        });
                        // Share.share(uri.toString());
                      },
                      // child: SizedBox(
                      //   height: 40,
                      //   width: 40,
                      //   child: ImageContainer(
                      //     colors: Colors.white,
                      //     imageName: Image.asset(
                      //       "images/28_PRODUCT DETAIL 2-9.png",
                      //     ),
                      //   ),
                      // ),
                    )),
                box.read("token") != null
                    ? Consumer<CartCounterStore>(
                        builder: (context, valuee, child) {
                        if (!valuee.loader4) {
                          var wishlistid = widget.wishList;
                          if (valuee.wishlist!.data != null) {
                            var iswish = valuee.wishlist!.data!
                                .where((ele) => ele.sku == value.sku!);
                            if (iswish.isNotEmpty) {
                              wishlistid = true;
                            } else {
                              wishlistid = false;
                            }
                          }
                          return Positioned(
                            top: 20,
                            right: 20,
                            child: InkWell(
                              onTap: () async {
                                !wishlistid
                                    ? valuee.addfavorite(
                                        productId: widget.productId)
                                    : valuee.deletefavorite(
                                        productId: widget.productId);
                                Provider.of<CartCounterStore>(context,
                                        listen: false)
                                    .initialState();

                                Provider.of<CartCounterStore>(context,
                                        listen: false)
                                    .fetchFavourite(loadVar: "_");
                              },
                              child: valuee.loader10
                                  ? Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white),
                                      child: Icon(
                                        wishlistid
                                            ? Icons.favorite_outlined
                                            : Icons.favorite_outline,
                                        color: wishlistid
                                            ? primaryColor.withOpacity(0.8)
                                            : borderFavIconColor,
                                        size: 25,
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 29,
                                      width: 29,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      })
                    // })
                    //  Consumer<CartCounterStore>(
                    //     builder: (context, value, child) {
                    //     return IconFavourite(
                    //       right: 20,
                    //       top: 60,
                    //       isSelected: 0 == 0 ? false : true,
                    //       onFavourite: () {
                    //         /// **** is important ******////

                    //         0 == 0
                    //             ? value.addfavorite(productId: 1)
                    //             : value.deletefavorite(productId: 1);
                    //       },
                    //     );
                    //   })
                    : const SizedBox()
              ],
            );
          } else {
            return const SizedBox(
              height: 360,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }));
  }
}

class ImageContainer extends StatelessWidget {
  final Image imageName;
  final Color colors;
  const ImageContainer({
    required this.colors,
    required this.imageName,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: imageName,
      ),
      decoration:
          BoxDecoration(color: colors, borderRadius: BorderRadius.circular(50)),
    );
  }
}

// class DynamicLinkService {
//   Future<Uri> createDynamicLink() async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://your.page.link',
//       link: Uri.parse('https://your.url.com'),
//       androidParameters: AndroidParameters(
//         packageName: 'your_android_package_name',
//         minimumVersion: 1,
//       ),
//       /*  iosParameters: IosParameters(
//           bundleId: 'your_ios_bundle_identifier',
//           minimumVersion: '1',
//           appStoreId: 'your_app_store_id',
//         ), */
//     );
//     final ShortDynamicLink shortLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(parameters);

//     final Uri shortUrl = shortLink.shortUrl;
//     return shortUrl;
//   }
// }
