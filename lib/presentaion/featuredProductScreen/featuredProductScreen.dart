import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/store/widgets/cartBagWidget.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/bottamCartIndicatorWidget.dart';
import 'package:fazzmi/widgets/serach_bar.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../core/constants/commonMethods.dart';
import '../productDetailPage/screenProductDetailPage.dart';

class ScreenFeaturedProduct extends StatefulWidget {
  const ScreenFeaturedProduct({
    Key? key,
    required this.appTitle,
    required this.shopId,
    required this.shopType,
    required this.parentcateryId,
    required this.storeName,
    required this.storeId,
  }) : super(key: key);
  final String appTitle, storeName, parentcateryId;

  final int shopId, shopType, storeId;

  @override
  State<ScreenFeaturedProduct> createState() => ScreenFeaturedProductState();
}

class ScreenFeaturedProductState extends State<ScreenFeaturedProduct>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  bool noMoreProducts = false;
  int page = 1;
  String? outOfStockMsg;

  fetchData({loadVar, page, categoryId = 0}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CartCounterStore>(context, listen: false)
          .fetchFeaturedProduct(
              loadVar: loadVar,
              categoryId: categoryId,
              storeId: widget.storeId,
              page: page);

      await Provider.of<CartCounterStore>(context, listen: false)
          .loadCartDataFnc();
    });
  }

  Consumer<CartCounterStore> _buildCartWidget() {
    return Consumer<CartCounterStore>(
      builder: (context, value, child) => (value.loader)
          ? const SizedBox(
              width: 5,
              height: 5,
            )
          : WidgetCartBag(
              storename: widget.appTitle,
              cartCount: value.cartCount,
            ),
    );
  }

  Future<void> _scrollListener() async {
    final cartCounterStore =
        Provider.of<CartCounterStore>(context, listen: false);

    if (cartCounterStore.isLoadMore) return;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Fetch data and check if there are more items available.
      // final bool hasMoreItems =
      await fetchData(
        categoryId: widget.parentcateryId,
        loadVar: '_isLoadMore',
        page: page += 1,
      );

      // if (!hasMoreItems) {
      //   // Show the alert message when there are no more items.
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text('No More Products'),
      //       content: Text('There are no more products available.'),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text('OK'),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CartCounterStore>(context, listen: false).clearProductList();

      await Provider.of<CartCounterStore>(context, listen: false)
          .initialState();
    });

    fetchData(
        loadVar: '_isLoading', page: page, categoryId: widget.parentcateryId);
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.appTitle,
        icon: Icons.arrow_back_ios,
        action: [_buildCartWidget()],
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Stack(
        children: [
          Column(
            children: [
              const CustomSearchBar(text: "Search"),
              Consumer<CartCounterStore>(builder: (context, value, child) {
                if (!value.isLoad) {
                  return Expanded(
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        height20,
                        buildGridView(value, widget.shopType),
                        if (value.isLoadMore)
                          Container(
                            height: 45,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(5.0),
                            child: const CircularProgressIndicator(),
                          ),
                        if (!value.isLoadMore &&
                            value.featuredProductList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text("End of products"),
                          ),
                      ],
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }),
              BottamCartIndicatorWidget(
                storeName: widget.appTitle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildGridView(CartCounterStore value, int shoptype) {
    var box = GetStorage();
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / (shoptype == 1 ? 4.9 : 4),
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10),
        itemCount: value.featuredProductList.length,
        itemBuilder: (BuildContext ctx, index) {
          int qnt = 0, cartId = 0;
          var item = value.featuredProductList[index];
          int productid = int.tryParse('${item.id}')!;
          if (box.read("quoteIdLogin") != null) {
            var isCart = value.productDetailList?.items!
                .where((ele) => ele.sku == item.sku);
            if (isCart != null && isCart.isNotEmpty) {
              qnt = isCart.first.qty!;
              cartId = isCart.first.itemId!;
            }
          }
          if (box.read("quoteIdGuest") != null) {
            var isCart =
                value.guestCartList?.items!.where((ele) => ele.sku == item.sku);
            if (isCart != null && isCart.isNotEmpty) {
              qnt = isCart.first.qty!;
              cartId = isCart.first.itemId!;
            }
          }
          // var isCart = value.checkIsCart(sku: item.sku);
          var isFavourite = value.checkIsFavourite(sku: item.sku);
          return ProductItemWidget(
            storeid: widget.storeId,
            stock: item.stock,
            index: index,
            parentCategoryId: widget.parentcateryId,
            specialPrice: item.specialPrice.toString(),
            storeName: widget.storeName,
            loadCart: (index == value.itemIndex) ? true : false,
            shopType: widget.shopType.toString(),
            sku: item.sku!,
            key: ValueKey(index),
            productid: productid,
            image: item.image!,
            name: item.name!,
            price: item.price != null ? '${item.price}' : '0',
            qty: qnt,
            value: value,
            btnCart: (item.type == 'simple') ? true : false,
            addCart: () async {
              bool res = await value.addCartFnc(
                  sku: item.sku,
                  qty: qnt,
                  productid: qnt > 0 ? cartId : productid,
                  index: index,
                  categoryId: widget.parentcateryId,
                  loadVar: '_isCartLoad',
                  page: page,
                  storeId: widget.shopId);

              fetchData(
                  loadVar: '_', page: page, categoryId: widget.parentcateryId);
            },
            removeCart: () {
              bool res = value.deleteCartFnc(
                  sku: item.sku,
                  index: index,
                  qty: qnt,
                  productid: qnt > 0 ? cartId : productid);
              fetchData(
                  loadVar: '_', page: page, categoryId: widget.parentcateryId);
            },
            isAddCart: value.isCartLoad,
            isFavourite:
                (isFavourite != null && isFavourite.isNotEmpty) ? true : false,
            onFavourite: () {
              value.changeFavourite(
                  isAddFav: (isFavourite != null && isFavourite.isNotEmpty)
                      ? false
                      : true,
                  productid: productid);
              fetchData(loadVar: '_', categoryId: widget.parentcateryId);
            },
          );
        });
  }

  buildDeliverySubWidget({firstText, secondText}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextInput(
          text1: firstText,
          colorOfText: Colors.black,
          size: 15,
        ),
        TextInput(
          text1: secondText,
          colorOfText: Colors.grey,
          size: 11,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
  bool isloaderCart = false;

  void cartLoading() {
    if (!Provider.of<CartCounterStore>(context, listen: false)
        .storeCategoryloader) {
      setState(() {
        isloaderCart = true;
      });
    }

    Future.delayed(
        const Duration(milliseconds: 0),
        () => setState(() {
              isloaderCart = false;
            }));
  }
}

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget(
      {Key? key,
      required this.name,
      required this.price,
      required this.image,
      required this.qty,
      required this.storeid,
      required this.productid,
      required this.value,
      this.addCart,
      this.removeCart,
      this.isAddCart = false,
      this.isFavourite = false,
      this.onFavourite,
      this.btnCart = true,
      required this.sku,
      required this.shopType,
      required this.loadCart,
      required this.storeName,
      required this.specialPrice,
      required this.parentCategoryId,
      required this.index,
      required this.stock})
      : super(key: key);

  final String name, storeName;

  final String price, specialPrice, parentCategoryId;
  final String image;
  final String shopType;
  final int qty, index;
  final int storeid;
  final int stock;

  final String sku;

  final dynamic productid;
  final CartCounterStore value;
  final void Function()? addCart;
  final void Function()? removeCart;
  final bool isAddCart, isFavourite, btnCart, loadCart;
  final void Function()? onFavourite;

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(int.parse('F7F7F7', radix: 16)).withOpacity(1.0);
    double acctualPrice = double.parse(price.replaceAll('+', ''));
    double offerPrice = double.parse(specialPrice.replaceAll('+', ''));

    var boxWidth = MediaQuery.of(context).size.width / 2.3;
    var boxHeight =
        MediaQuery.of(context).size.height / (shopType == "1" ? 3.7 : 5);

    // log("Height: $boxHeight");
    // log("Width: $boxWidth");
    // Height: 152.0
    // Width: 156.52173913043478

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenProductDetail(
                storeId: storeid,
                parentCategoryId: parentCategoryId,
                productId: productid,
                wishList: isFavourite,
                storeName: storeName,
                sku: sku,
                qty: qty,
                productName: name,
                shopType: shopType),
          ),
        );
      },
      child: SizedBox(
        // height: MediaQuery.of(context).size.height / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(color: myColor),
                    child: Image.network(
                      image,
                      height: boxHeight,
                      width: boxWidth,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          height: boxHeight,
                          width: boxWidth,
                          'images/22_LOGIN PAGE-4.png',
                          color: Colors.black.withOpacity(0.4),
                        );
                      },
                    ),
                  ),
                ),
                //favourite button
                if (value.quoteId != null)
                  IconFavourite(
                      index: 0,
                      right: 7,
                      top: 7,
                      isSelected: isFavourite,
                      onFavourite: onFavourite),
                if (shopType == "1" ? false : true)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: InkWell(
                      onTap: () {},
                      child: Consumer<CartCounterStore>(
                          builder: (context, value, child) {
                        return AnimatedContainer(
                          height: 40,
                          width: (qty > 0) ? (boxWidth - 22) : 40,
                          // width: (value.cartIndex == index && qty > 0 ||
                          //         value.loader)
                          //     ? (boxWidth - 22)
                          //     : 40,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (qty > 0)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, bottom: 2),
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // width5,
                                      //// decrement
                                      InkWell(
                                          onTap: removeCart,
                                          child: SizedBox(
                                            width: 50,
                                            child: qty == 1
                                                ? const Icon(
                                                    Icons
                                                        .delete_outline_outlined,
                                                    color: primaryColor,
                                                    size: 22,
                                                  )
                                                : const Icon(
                                                    Icons.remove_rounded,
                                                    color: primaryColor,
                                                    size: 22,
                                                  ),
                                          )),
                                      width10,
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 24,
                                        width: 30,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 1),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2),
                                                child:
                                                    Consumer<CartCounterStore>(
                                                        builder: (context,
                                                            value, child) {
                                                  return (value
                                                              .addtoCartLoader &&
                                                          value.cartIndex ==
                                                              index)
                                                      ? const SizedBox(
                                                          height: 25,
                                                          width: 25,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                        )
                                                      : TextInput(
                                                          text1: '$qty',
                                                          colorOfText:
                                                              Colors.black,
                                                          size: 16,
                                                        );
                                                }),
                                              ),
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                              height5,
                              // width5,
                              //// INCREMENT
                              InkWell(
                                onTap: () async {
                                  if (stock == 0 || qty >= stock) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Sorry!!"),
                                            content: const Text(
                                                "This Product is Out Of Stock!"),
                                            actions: [
                                              TextButton(
                                                child: const Text("OK"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  } else {
                                    addCart!();
                                  }
                                },
                                child: Consumer<CartCounterStore>(
                                    builder: (context, value, child) {
                                  return (value.cartIndex == index &&
                                          qty == 0 &&
                                          value.addtoCartLoader)
                                      ? const SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(
                                            Icons.add_rounded,
                                            color: primaryColor,
                                            size: 22,
                                          ),
                                        );
                                }),
                              ),

                              // width5,
                            ],
                          ),
                        );
                      }),
                    ),
                  )
              ],
            ),
            height5,
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: TextInput(maxLines: 2, size: 13, text1: " $name")),
                  TextInput(
                    text1: "₹ ${offerPrice == 0 ? acctualPrice : offerPrice}",
                    size: 15,
                    weight: FontWeight.w300,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}

class IconFavourite extends StatelessWidget {
  const IconFavourite({
    Key? key,
    required this.isSelected,
    this.onFavourite,
    required this.right,
    required this.top,
    required this.index,
  }) : super(key: key);

  final bool isSelected;
  final double top, right;
  final int index;
  final void Function()? onFavourite;

  @override
  Widget build(BuildContext context) {
    Decoration decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(35),
      border: Border.all(
        color: borderFavIconColor,
      ),
    );

    return Consumer<CartCounterStore>(builder: (context, value, child) {
      return Positioned(
        top: top == null ? 7 : top,
        right: right == null ? 7 : right,
        child: InkWell(
          onTap: onFavourite,
          child: Container(
            height: 25,
            width: 25,
            decoration: null,
            child: (index == value.favIndex)
                ? const CircularProgressIndicator()
                : Icon(
                    isSelected
                        ? Icons.favorite_outlined
                        : Icons.favorite_outline,
                    color: isSelected
                        ? primaryColor.withOpacity(0.8)
                        : borderFavIconColor,
                    size: 25,
                  ),
          ),
        ),
      );
    });
  }

  calcPercentage(price, offerP) {
    var percentage = ((price - offerP) / price) * 100;
    if (percentage.isNaN) {
      return '';
    } else {
      return '${percentage.toInt()}% OFF';
    }
  }
}
