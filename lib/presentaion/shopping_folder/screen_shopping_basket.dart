import 'package:fazzmi/core/constants/commonMethods.dart';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/login/login_page/screen_login.dart';
import 'package:fazzmi/presentaion/my_account/addressbook/screen_addressbook.dart';
import 'package:fazzmi/presentaion/store/screen_stores.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/customButton2.dart';
import 'package:fazzmi/widgets/leading_app_bar.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class ScreenShoppingBasket extends StatefulWidget {
  const ScreenShoppingBasket({
    super.key,
    required this.storeName,
  });
  final String storeName;

  @override
  State<ScreenShoppingBasket> createState() => _ScreenShoppingBasketState();
}

class _ScreenShoppingBasketState extends State<ScreenShoppingBasket> {
  final _addNoteController = TextEditingController();
  var box = GetStorage();
  var storeName;
  var storeId;
  var parentCategoryId;
  var shoptype;
  var price;
  var special_price;
  var stock;
  var qty;

  // int quantity = 0;
  @override
  void initState() {
    super.initState();
    loadData();
    loadData2();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartCounterStore>(context, listen: false).setCartIndex(null);
      if (box.read("quoteIdLogin") != null) {
        Provider.of<CartCounterStore>(context, listen: false)
            .getCartProductDetailsLogin();
      } else if (box.read("quoteIdGuest") != null) {
        Provider.of<CartCounterStore>(context, listen: false).intialCall();
        // .getCartProductDetailsGuest();
      }
    });
  }

  loadData2() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (box.read("quoteIdLogin") != null) {
        Provider.of<CartCounterStore>(context, listen: false).intialCallGst();
        // .getCartTotalGstList();
      } else if (box.read("quoteIdGuest") != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<CartCounterStore>(context, listen: false)
              .getGuestTotalGstList();
        });
      }
    });
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Consumer<CartCounterStore>(
        builder: (context, cartCounterStore, child) {
          return (!cartCounterStore.loader2)
              ? buildBody(context, cartCounterStore)
              : buildLoader();
        },
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return CustomAppBarLeading(
      ontap: () {
        Navigator.pop(context);
      },
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextInput(
            text1: "Basket",
            colorOfText: Colors.black,
            size: 15,
            weight: FontWeight.bold,
          ),
          Consumer<CartCounterStore>(
            builder: (context, value, child) {
              // if (!value.loader) {
              if (box.read("token") == null) {
                if (value.guestCartList!.items!.isNotEmpty) {
                  storeName = value.guestCartList!.items![0]
                      .extensionAttributes!.store_name!;
                  storeId = value
                      .guestCartList!.items![0].extensionAttributes!.store!;
                  parentCategoryId = value.guestCartList!.items![0]
                      .extensionAttributes!.parent_category_id!
                      .toString();
                  shoptype =
                      value.guestCartList!.items![0].productType == "simple"
                          ? 2
                          : 1;
                  box.write("storeName", (storeName));
                  box.write("parentCategoryId", (parentCategoryId.toString()));
                  box.write("storeid", (storeId));
                  box.write("shoptype", (shoptype));
                  return TextInput(
                    text1: storeName,
                    colorOfText: Colors.grey,
                    size: 10,
                  );
                } else {
                  return const SizedBox();
                }
              }

              if (value.productDetailList!.items!.isNotEmpty) {
                storeName = value.productDetailList!.items![0]
                    .extensionAttributes!.store_name!;
                storeId = value
                    .productDetailList!.items![0].extensionAttributes!.store!;
                qty = value.productDetailList!.items![0].qty!;
                stock = value
                    .productDetailList!.items![0].extensionAttributes!.stock!;
                parentCategoryId = value.productDetailList!.items![0]
                    .extensionAttributes!.parent_category_id!;
                shoptype =
                    value.productDetailList!.items![0].productType == "simple"
                        ? 2
                        : 1;

                box.write("storeName", (storeName));
                box.write("storeId", (storeId));
                box.write("qty", (qty));
                box.write("stock", (stock));
                box.write("parentCategoryId", (parentCategoryId.toString()));
                box.write("shoptype", (shoptype));

                return TextInput(
                  text1: storeName,
                  colorOfText: Colors.grey,
                  size: 10,
                );
              } else {
                return const SizedBox();
              }
              // } else {
              //   return const SizedBox();
              // }
            },
          )
        ],
      ),
    );
  }

  buildBody(BuildContext context, CartCounterStore cartCounterStore) {
    var data = (box.read("token") == null)
        ? cartCounterStore.guestCartList!.items
        : cartCounterStore.productDetailList!.items;

    return (data != null && data.isNotEmpty)
        ? Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    Column(
                      children: List.generate(
                        data.length,
                        (index) => buildCartItem(
                          context,
                          cartCounterStore,
                          data,
                          index,
                        ),
                      ),
                    ),
                    height20,
                    buildContainNotePayment(),
                  ],
                ),
              ),
              buildBottomIndicatorWidget(),
            ],
          )
        : buildNoCart();
  }

  buildBottomIndicatorWidget() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<CartCounterStore>(builder: (context, value, child) {
          return Column(
            children: [
              if (value.leneraprogresIndicatorValue < 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_sharp,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextInput(
                            text1:
                                "add ₹${value.morePrice < 0 ? 0.0 : value.morePrice} more to place your order"
                                "",
                            weight: FontWeight.bold,
                            size: 15),
                      ),
                    ],
                  ),
                ),
              if (value.leneraprogresIndicatorValue < 1)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      color: primaryColor,
                      backgroundColor: const Color.fromARGB(255, 223, 220, 220),
                      value: value.leneraprogresIndicatorValue,
                    )),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomButton2(
                      buttonAction: () {
                        // var shoptype = box.read("shoptype");
                        // var storeId = box.read("storeId");
                        // var storeName = box.read("storeName");
                        // var parentCategoryId = box.read("parentCategoryId");

                        // var storeId1 = int.parse(storeId);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenStores(
                                      parentCategoryId:
                                          parentCategoryId.toString(),
                                      shoptype: shoptype,
                                      storeId: int.parse(storeId),
                                      storename: storeName,
                                    )));
                      },
                      textSize: 18,
                      buttonName: "More items",
                      height: 60,
                      textColor: primaryColor,
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width / 2.7,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomButton2(
                      buttonAction: () {
                        if (box.read("token") == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Please Login!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel")),
                                    TextButton(
                                        onPressed: () async {
                                          String refresh =
                                              await Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ScreenLoginPage()));

                                          if (refresh == "refresh") {
                                            setState(() {
                                              loadData2();
                                              loadData();
                                            });
                                          }
                                        },
                                        child: const Text("login"))
                                  ],
                                );
                              });
                        } else {
                          value.leneraprogresIndicatorValue < 1
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text("Please Add more items!"),
                                      content: Text(
                                          "For checkout minimum order should be ₹${value.morePrice > 0 ? 300 : value.morePrice}"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel")),
                                      ],
                                    );
                                  })
                              : WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                  // await Provider.of<
                                  //             ShipppingAddressConfirmProvider>(
                                  //         context,
                                  //         listen: false)
                                  // .getCheckoutpage();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ScreenAddressBook(
                                                  isBasket: true)

                                          // const ScreenCheckOut()
                                          ));
                                });
                        }
                      },
                      textSize: 18,
                      buttonName: "Checkout",
                      height: 60,
                      textColor: value.leneraprogresIndicatorValue < 1
                          ? primaryColor
                          : Colors.white,
                      color: value.leneraprogresIndicatorValue < 1
                          ? Colors.grey.shade300
                          : primaryColor,
                      width: MediaQuery.of(context).size.width / 2.6,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  buildNoCart() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/bag.png", height: 50, width: 50),
          const TextInput(
              text1: "Your cart is empty", weight: FontWeight.bold, size: 20),
          const TextInput(
              text1: "Be sure to fill your cart with something you like"),
          height40
        ],
      ),
    );
  }

  buildLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  buildCartItem(BuildContext context, CartCounterStore value, data, index) {
    double acctualPrice = double.parse(
        data[index].extensionAttributes!.price!.toString().replaceAll("+", ""));

    double offerPrice = double.parse(data[index]
        .extensionAttributes!
        .special_price!
        .toString()
        .replaceAll("+", ""));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                    height: 80,
                    width: 80,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/Fazzmi_logo.png',
                      fit: BoxFit.cover,
                      image: data[index].extensionAttributes!.image!,
                    )),
              ),
              width10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 135,
                    child: TextInput(
                      maxLines: 2,
                      text1: data[index].name!,
                      colorOfText: Colors.black,
                      size: 13,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: TextInput(
                      text1: "₹ ${offerPrice == 0 ? acctualPrice : offerPrice}",
                      size: 15,
                      weight: FontWeight.w300,
                    ),
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
            ],
          ),
        ),
        data[index].qty == null
            ? ElevatedButton(
                onPressed: () {},
                child: const TextInput(text1: "Add"),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Material(
                  elevation: 1,
                  child: SizedBox(
                    height: 35,
                    width: 95,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            value.decrementCart(
                                productid: data[index].itemId,
                                qty: data[index].qty!,
                                name: data[index].sku,
                                index: index);
                          },
                          child: data[index].qty == 1
                              ? const Icon(
                                  Icons.delete_outline,
                                  color: primaryColor,
                                  size: 19,
                                )
                              : SizedBox(
                                  width: 30,
                                  height: 15,
                                  child: Image.asset(
                                      "images/38_STORE_RED-MINUS-.png")),
                        ),
                        (value.loader && value.cartIndex == index)
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : TextInput(
                                text1: data[index].qty.toString(),
                                size: 19,
                              ),

                        /// increment
                        InkWell(
                          onTap: () async {
                            value.addtoCart(
                                productid: data[index].itemId,
                                qty: data[index].qty!,
                                name: data[index].sku,
                                index: index);
                          },
                          child: SizedBox(
                              width: 20,
                              height: 15,
                              child: Image.asset("images/38_STORE_RED-64.png")),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  buildContainNotePayment() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: TextInput(text1: "Special Request", size: 20),
          ),
          height20,
          const Row(
            children: [
              Icon(Icons.mode_comment_outlined, color: Colors.grey),
              width10,
              TextInput(text1: "Add a note")
            ],
          ),
          height10,
          Container(
            padding: const EdgeInsets.only(left: 20, right: 5),
            child: TextFormField(
              maxLength: 25,
              // inputFormatters: [
              //   new LengthLimitingTextInputFormatter(42),
              // ],
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                hintText: "Anything else we need to know?",
              ),
              controller: _addNoteController,
            ),
          ),
          height20,
          const TextInput(text1: "Payment Summary", size: 20),
          height20,
          buildPaymentSummary(),
        ],
      ),
    );
  }

  buildPaymentSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInput(text1: "Subtotal", size: 12),
            height5,
            TextInput(
              text1: "Delivery Charge",
              size: 12,
              colorOfText: Colors.grey,
            ),
            height5,
            // const TextInput(
            //   text1: "GST",
            //   size: 12,
            //   colorOfText: Colors.grey,
            // ),
            // height5,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInput(text1: "Grand Total", size: 12),
                TextInput(
                  text1: "(Including VAT)",
                  size: 8,
                  colorOfText: Colors.grey,
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Consumer<CartCounterStore>(builder: (context, value, child) {
              return TextInput(
                text1:
                    "₹ ${box.read("quoteIdGuest") == null ? value.cartTotalGstList!.subtotalInclTax! : value.guestTotalGstList!.subtotalInclTax!}",
                size: 12,
              );
            }),
            height5,
            Consumer<CartCounterStore>(builder: (context, value, child) {
              return TextInput(
                text1:
                    "₹ ${box.read("quoteIdGuest") == null ? value.cartTotalGstList!.shippingAmount! : value.guestTotalGstList!.shippingAmount!}",
                size: 12,
                colorOfText: Colors.grey,
              );
            }),
            height5,
            // Consumer<CartCounterStore>(builder: (context, value, child) {
            //   return TextInput(
            //     text1:
            //         "₹ ${box.read("quoteIdGuest") == null ? value.cartTotalGstList!.taxAmount! : value.guestTotalGstList!.taxAmount!}",
            //     size: 12,
            //     colorOfText: Colors.grey,
            //   );
            // }),
            height5,
            Consumer<CartCounterStore>(builder: (context, value, child) {
              return TextInput(
                text1:
                    "₹ ${box.read("quoteIdGuest") == null ? value.cartTotalGstList!.baseGrandTotal! : value.guestTotalGstList!.baseGrandTotal!}",
                colorOfText: primaryColor,
                size: 17,
              );
            }),
          ],
        ),
      ],
    );
  }

  calcPercentage1(price, offerP) {
    var percentage = ((price - offerP) / price) * 100;
    if (percentage.isNaN) {
      return '';
    } else {
      return '${percentage.toInt()}% OFF';
    }
  }
}
