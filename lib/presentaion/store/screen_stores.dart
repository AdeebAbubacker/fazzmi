import 'package:fazzmi/presentaion/featuredProductScreen/featuredProductScreen.dart';
import 'package:fazzmi/presentaion/store/widgets/alert/alertWidget.dart';
import 'package:fazzmi/presentaion/store/widgets/bottomCartContainerWidget.dart';
import 'package:fazzmi/presentaion/store/widgets/cartBagWidget.dart';
import 'package:fazzmi/presentaion/store/widgets/screen_products.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/bottamCartIndicatorWidget.dart';
import 'package:fazzmi/widgets/serach_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../model/storesubcategorymodel/store_subcategory_model.dart';
import '../../provider/cartInStore.dart';
import '../../services/api_services.dart';
import '../../widgets/deliveryTimeMInOrderFeeWidget.dart';
import '../../widgets/textInput.dart';
import '../shopping_folder/screen_shopping_basket.dart';

class ScreenStores extends StatefulWidget {
  ScreenStores(
      {Key? key,
      required this.storename,
      required this.shoptype,
      required this.storeId,
      required this.parentCategoryId})
      : super(key: key);
  final String storename, parentCategoryId;
  final int shoptype;
  final int storeId;

  @override
  State<ScreenStores> createState() => _ScreenStoresState();
}

class _ScreenStoresState extends State<ScreenStores>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var box = GetStorage();
  var cartData;
  var loginData;
  var cartItem;
  var isguest = true;
  var totalPrice = 0;
  @override
  void initState() {
    super.initState();
    loadData();
    loadData2();
    // clearStoreProductListFunction();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CartCounterStore>(context, listen: false)
          .getStoreProductDeatils(storeId: widget.storeId);
      await Provider.of<CartCounterStore>(context, listen: false).getWishList();
      Provider.of<CartCounterStore>(context, listen: false).initialState();
      Provider.of<CartCounterStore>(context, listen: false).loadCartDataFnc();
    });
  }

  // clearStoreProductListFunction() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Provider.of<CartCounterStore>(context, listen: false)
  //         .clearStoreProductList();
  //   });
  // }

  loadData2() {
    if (box.read("token") == null) {
      if (box.read("quoteIdGuest") == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Provider.of<CartCounterStore>(context, listen: false)
              .guestUsers();
        });
      } else {
        var guestQuoteId = box.read("quoteIdGuest");
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          cartItem = await Provider.of<CartCounterStore>(context, listen: false)
              .getCartProductDetailsGuest();
          checkStoreCart(cartItem);
        });
      }
    } else {
      if (box.read("quoteIdLogin") == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Provider.of<CartCounterStore>(context, listen: false)
              .loginUsers();
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          cartItem = await Provider.of<CartCounterStore>(context, listen: false)
              .getCartProductDetailsLogin();

          checkStoreCart(cartItem);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Provider.of<CartCounterStore>(context, listen: false)
              .getWishList();
        });
      }
    }
  }

  checkStoreCart(cartItem) async {
    if (cartItem!.items!.isNotEmpty) {
      if (cartItem.items![0].extensionAttributes!.store ==
          '${widget.storeId}') {
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AlertAndroidWidget(
                    title: Align(
                        alignment: Alignment.center,
                        child: Text("Start a new basket?")),
                    content: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Your basket contains items from' ${cartItem!.items![0].extensionAttributes!.store_name!}'. Do you want to clear the cart and shop from ${widget.storename}?",
                        textAlign: TextAlign.left,
                      ),
                    ),
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
                  ),
                ),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.storename,
        icon: Icons.arrow_back_ios,
        action: [_buildCartWidget()],
      ),
      body: Column(
        children: [
          const CustomSearchBar(text: "Search for items"),
          Expanded(
              child: ListView(
            children: [
              // buildDeliverySection(),

              Consumer<CartCounterStore>(
                  builder: (context, deliveryValue, child) {
                if (!deliveryValue.storeCategoryloader) {
                  return DeliveryTimeMInOrderFeeWidget(
                    deliveryfee: "",
                    deliverydate:
                        deliveryValue.storeProductlist!.data!.deliveryDate!,
                    minOrder:
                        deliveryValue.storeProductlist!.data!.minOrderAmount!,
                  );
                } else {
                  return const SizedBox();
                }
              }),

              const Divider(),
              _buildShopByCategoryTextWidget(),
              ShopByCategory(
                shoptype: widget.shoptype,
                parentCategoryId: widget.parentCategoryId,
                storeName: widget.storename,
                storeId: widget.storeId,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextInput(text1: "Featured Products", size: 22),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScreenFeaturedProduct(
                                  storeId: widget.storeId,
                                  storeName: widget.storename,
                                  parentcateryId: widget.parentCategoryId,
                                  shopId: widget.shoptype,
                                  shopType: widget.shoptype,
                                  appTitle: widget.storename,
                                ),
                              ));
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: primaryColor,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: Consumer<CartCounterStore>(
                    builder: (context, value, child) {
                  if (!value.storeCategoryloader) {
                    var data = value.storeProductlist!.data!.featuredProducts;
                    if (value
                        .storeProductlist!.data!.featuredProducts!.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            int qnt = 0;
                            int productid = int.parse(data[index].productId!);
                            int wishListProductId =
                                int.parse(data[index].productId!);
                            int wishlistid = 0;
                            int doubleStore = 0;
                            return Consumer<CartCounterStore>(
                                builder: (context, value, child) {
                              Widget result = const SizedBox();
                              try {
                                if (box.read("quoteIdLogin") != null) {
                                  var isCart = value.productDetailList!.items!
                                      .where(
                                          (ele) => ele.sku == data[index].sku);
                                  if (isCart.isNotEmpty) {
                                    qnt = isCart.first.qty!;
                                    productid = isCart.first.itemId!;
                                  }
                                  /* -----@checking favourite----- */
                                  if (value.wishlist!.data != null) {
                                    var iswish = value.wishlist!.data!.where(
                                        (ele) => ele.sku == data[index].sku);
                                    if (iswish.isNotEmpty) {
                                      wishlistid =
                                          int.parse(iswish.first.productId!);
                                    }
                                  }
                                  if (value
                                      .productDetailList!.items!.isNotEmpty) {
                                    if (value.productDetailList!.items![0]
                                            .extensionAttributes!.store !=
                                        widget.storeId.toString()) {
                                      doubleStore = 1;
                                    }
                                  }
                                   return HorizontalListStore(
                                      salable_qty: data[index].salable_qty,
                                      parentCategoryId: widget.parentCategoryId,
                                      index: index,
                                      wishlistProductId: wishListProductId,
                                      storeName: widget.storename,
                                      doubleStore: doubleStore,
                                      storeId: widget.storeId,
                                      sku: data[index].sku!,
                                      featuredProductId:
                                          int.parse(data[index].productId!),
                                      wishList: wishlistid,
                                      shopType: data[index].shopType!,
                                      image: data[index].image!,
                                      name: data[index].name!,
                                      price: data[index].price!,
                                      specialPrice:
                                          data[index].specialPrice.toString(),
                                      qty: qnt,
                                      productid: productid);
                               
                                 
                                }

                                //// guest users

                                else if (box.read("quoteIdGuest") != null) {
                                  var isCart = value.guestCartList!.items!
                                      .where(
                                          (ele) => ele.sku == data[index].sku);
                                  if (isCart.isNotEmpty) {
                                    qnt = isCart.first.qty!;
                                    productid = isCart.first.itemId!;
                                  }
                                  if (value.guestCartList!.items!.isNotEmpty) {
                                    if (value.guestCartList!.items![0]
                                            .extensionAttributes!.store !=
                                        widget.storeId.toString()) {
                                      doubleStore = 1;
                                    }
                                  }

                                  return HorizontalListStore(
                                      salable_qty: data[index].salable_qty,
                                      parentCategoryId: widget.parentCategoryId,
                                      index: index,
                                      wishlistProductId: wishListProductId,
                                      storeName: widget.storename,
                                      doubleStore: doubleStore,
                                      storeId: widget.storeId,
                                      sku: data[index].sku!,
                                      featuredProductId:
                                          int.parse(data[index].productId!),
                                      wishList: wishlistid,
                                      shopType: data[index].shopType!,
                                      image: data[index].image!,
                                      name: data[index].name!,
                                      price: data[index].price!,
                                      specialPrice:
                                          data[index].specialPrice.toString(),
                                      qty: qnt,
                                      productid: productid);
                                } else {
                                  return result;
                                }
                              } catch (e) {
                                return result;
                              }

                              //  else {
                              //   return SizedBox();
                              //   HorizontalListStore(
                              //       doubleStore: doubleStore,
                              //       storeId: widget.storeId,
                              //       sku: data[index].sku!,
                              //       featuredProductId:
                              //           int.parse(data[index].productId!),
                              //       wishList: wishlistid,
                              //       shopType: data[index].shopType!,
                              //       image: data[index].image!,
                              //       name: data[index].name!,
                              //       price: data[index].price!,
                              //       specialPrice: data[index].specialPrice ?? '0',
                              //       qty: qnt,
                              //       productid: productid);
                              // }

                              // } else {
                              //   return const SizedBox(
                              //     child: TextInput(text1: "no data"),
                              //   );
                              // }
                            });
                          });
                    } else {
                      return const Center(
                        child: TextInput(text1: "No Data"),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
              )
            ],
          )),
          // Consumer<CartCounterStore>(builder: (context, value, child) {
          //   return value.commoLoader
          //       ? Container(
          //           height: MediaQuery.of(context).size.height,
          //           width: MediaQuery.of(context).size.width,
          //           color: Colors.white.withOpacity(0.3),
          //           child: Center(
          //             child: JumpingDotsProgressIndicator(
          //               color: primaryColor,
          //               fontSize: 50.0,
          //             ),
          //           ),
          //         )
          //       : const SizedBox();
          // }),
          // buildBottomIndicatorWidget(),
          BottamCartIndicatorWidget(
            storeName: widget.storename,
          )
        ],
      ),
    );
  }

  Padding _buildShopByCategoryTextWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: TextInput(
        text1: "Shop by Category",
        size: 20,
      ),
    );
  }

  Consumer<CartCounterStore> _buildCartWidget() {
    return Consumer<CartCounterStore>(
      builder: (context, value, child) => (value.loader)
          ? const SizedBox()
          : WidgetCartBag(
              storename: widget.storename,
              cartCount: value.cartCount,
            ),
    );
  }

  Container buildBottomIndicatorWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: null,
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<CartCounterStore>(builder: (context, value, child) {
          return Column(
            children: [
              if (value.leneraprogresIndicatorValue < 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextInput(
                            text1:
                                "Add ₹ ${value.morePrice < 0 ? 0.0 : value.morePrice} more to place your order"
                                "",
                            weight: FontWeight.bold,
                            size: 13),
                      )
                    ],
                  ),
                ),
              if (value.leneraprogresIndicatorValue < 1)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      color: primaryColor,
                      backgroundColor: const Color.fromARGB(255, 223, 220, 220),
                      value: value.leneraprogresIndicatorValue,
                    )),
              if (value.leneraprogresIndicatorValue >= 0.1)
                WidgetBottomCart(
                  isApptheme:
                      value.leneraprogresIndicatorValue >= 1 ? true : false,
                  count: value.cartCount,
                  price: double.parse(value.totalPrice.toStringAsFixed(3)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ScreenShoppingBasket(
                              storeName: widget.storename,
                            )),
                      ),
                    );
                  },
                ),
            ],
          );
        }),
      ),
    );
  }

  // Column buildDeliverySubWidget({firstText, secondText, ruppes}) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Row(
  //         children: [
  //           ruppes == true
  //               ? const Icon(
  //                   Icons.currency_rupee_outlined,
  //                   size: 12,
  //                 )
  //               : const SizedBox(),
  //           TextInput(
  //             text1: firstText,
  //             colorOfText: Colors.black,
  //             size: 15,
  //           ),
  //         ],
  //       ),
  //       TextInput(
  //         text1: secondText,
  //         colorOfText: Colors.grey,
  //         size: 11,
  //       )
  //     ],
  //   );
  // }
}

class ShopByCategory extends StatelessWidget {
  const ShopByCategory({
    Key? key,
    required this.storeId,
    required this.storeName,
    required this.parentCategoryId,
    required this.shoptype,
  }) : super(key: key);
  final int storeId, shoptype;

  final String storeName, parentCategoryId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StoreSubCategoryModel>(
        future: ApiServices().getStoreProductDeatils(
            storeId: storeId, parentCategoryId: parentCategoryId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.data!.storeCategory;
            if (data!.isNotEmpty) {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3 / 3.5,
                      crossAxisCount: 4,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemCount: data.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        Provider.of<CartCounterStore>(context, listen: false)
                            .setindex(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenFeaturedProduct(
                              storeId: storeId,
                              storeName: storeName,
                              parentcateryId: data[index].categoryId!,
                              shopId: shoptype,
                              shopType: shoptype,
                              appTitle:
                                  data[index].categoryTitle!, // storeName,
                            ),
                          ),
                        );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ScreenStoreSubCategory(
                        //               shopid: shoptype,
                        //               parerntcategoryId:
                        //                   int.parse(parentCategoryId),
                        //               index: index,
                        //               storeId: storeId,
                        //               storeName: storeName,
                        //             )));
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 7,
                        child: Column(
                          children: [
                            SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  fit: BoxFit.fill,
                                  data[index].categoryImage!,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                          child: Image.asset(
                                              "images/Fazzmi_logo.png")),
                                ),
                              ),
                              height: MediaQuery.of(context).size.width / 6,
                              width: MediaQuery.of(context).size.width / 6,
                            ),
                            height5,
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5.5,
                              child: TextInput(
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                text1: data[index].categoryTitle!,
                                size: 11,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const SizedBox(
                  height: 100,
                  child: Center(
                      child: TextInput(text1: "No Store Categories....")));
            }
          } else {
            return const SizedBox();
          }
        });
  }
}
