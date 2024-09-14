import 'dart:async';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/my_account/addressbook/screen_addressbook.dart';
import 'package:fazzmi/presentaion/delivery_location/widgets/mapWidget.dart';
import 'package:fazzmi/provider/shippingAddressConfirmationProvider.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../widgets/textInput.dart';
import '../login/login_page/screen_login.dart';
import '../payment/paymentSuccessDetailPage/paymentSuccessDetailPage.dart';

class ScreenCheckOut extends StatefulWidget {
  const ScreenCheckOut({Key? key}) : super(key: key);
  @override
  State<ScreenCheckOut> createState() => _ScreenCheckOutState();
}

enum PaymentMethod { debitOrCredit, googlepay, paytm, phonepay, cashondelivery }

var box = GetStorage();

class _ScreenCheckOutState extends State<ScreenCheckOut> {
  var options;
  @override
  void initState() {
    super.initState();
    razorpayCommonfunction();
  }

  void razorpayCommonfunction() {
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  /// *** razorpay main function

  void openCheckout({String? price, orderId}) async {
    var shippingAddress = box.read("shippingAddress");
    var telephone = shippingAddress[9];
    var profileInfo = box.read("profileInfo");
    options = {
      'image':
          'https://staging.fazzmi.com/pub/media/logo/default/22_LOGIN_PAGE-4.png',
      'key': 'rzp_live_XoNJoEsoghNbjG',
      'amount': "$price",
      'name': 'Fazzmi',
      // 'order_id': '$orderId',
      "theme": {"color": "#d32a2a"},
      'description': 'Purchased from Store 1',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "payment": {
        "capture": "automatic",
        "capture_options": {
          "automatic_expiry_period": 12,
          "manual_expiry_period": 7200,
          "refund_speed": "optimum"
        }
      },
      'prefill': {'contact': '$telephone', 'email': "${profileInfo[0]}"},
      'external': {
        'wallets': ['paytm']
      }
    };

    //   try {
    //     _razorpay.open(options);
    //   } catch (e) {}
    // }

    // void _handlePaymentSuccess(PaymentSuccessResponse response) {
    //   Provider.of<ShipppingAddressConfirmProvider>(context, listen: false)
    //       .invoice(orderId: response.orderId);
    //   Provider.of<ShipppingAddressConfirmProvider>(context, listen: false)
    //       .razorpayApiIntegraion(
    //           orderId: response.orderId,
    //           razorpaypaymentid: response.orderId,
    //           razorpayorderid: response.paymentId,
    //           razorpaysignature: response.signature);
    //   Future.delayed(const Duration(seconds: 3)).then((value) {
    //     Navigator.pop(context);
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => const PaymentSuccessDetailPage(
    //                   orderMethod: "Razorpay",
    //                   whereisFrom: true,
    //                 )));
    //   });

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        )),
        context: context,
        builder: (context) {
          return Container(
            height: 550,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 2),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
                height20,
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextInput(
                        text1: "Thank you for",
                        weight: FontWeight.bold,
                        size: 16),
                    TextInput(
                        text1: "your ordering",
                        weight: FontWeight.bold,
                        size: 16),
                    height20,
                    TextInput(
                        text1:
                            "Your order has been recieved. Sit back and relax.",
                        size: 13),
                    TextInput(
                        text1: "You will recieve an update as notification",
                        size: 13),
                    TextInput(text1: "once accepted by Cook", size: 13),
                    height20,
                    TextInput(
                        text1: "If not recived, you can contact seller from",
                        size: 13),
                    TextInput(text1: "My Order List.", size: 13),
                    // TextInput(text1: "${response.orderId}", size: 13),
                    height20,
                    TextInput(text1: "Order Something else", size: 13),
                    height20,
                  ],
                ),
              ],
            ),
          );
        });

    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   /* Fluttertoast.showToast(
  //       msg: "ERROR: " + response.code.toString() + " - " + response.message!,
  //       toastLength: Toast.LENGTH_SHORT); */
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           child: SizedBox(
  //             height: 200,
  //             width: MediaQuery.of(context).size.width - 10,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   const Align(
  //                     alignment: Alignment.center,
  //                     child: TextInput(
  //                       text1:
  //                           // response.walletName == null
  //                           //     ? "Payment Aborted by the User"
  //                           //     :
  //                           "Please try another payment method",
  //                       size: 15,
  //                     ),
  //                   ),
  //                   const Divider(
  //                     thickness: 2,
  //                   ),
  //                   SizedBox(
  //                     height: 40,
  //                     width: 80,
  //                     child: ElevatedButton(
  //                       child: const TextInput(
  //                         text1: "OK",
  //                         size: 20,
  //                         colorOfText: Colors.blueAccent,
  //                       ),
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(50.0)),
  //                         primary: Colors.white,
  //                         elevation: 0,
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });

  //   /* Fluttertoast.showToast(
  //       msg: "EXTERNAL_WALLET: " + response.walletName!,
  //       toastLength: Toast.LENGTH_SHORT); */
  // }

  // late Razorpay _razorpay;
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    var box = GetStorage();
    var shippingAddress = box.read("shippingAddress");
    var billingAddress = box.read("billingAddress");
    var shippingCity = shippingAddress[5];
    // var shippingArea = shippingAddress[10];

    var shippingStreet = shippingAddress[6];
    var shippingPhoneNumber = shippingAddress[9];
    var shippingState = shippingAddress[0];
    var shippingCountry = shippingAddress[3];
    var shippingPostCode = shippingAddress[4];

    // var shippingbuilding = shippingAddress[11];
    var billingCity = billingAddress[5];
    var billingStreet = billingAddress[6];
    var billingPhoneNumber = billingAddress[9];
    // var billingState = billingAddress[0];
    var billingCountry = billingAddress[3];
    var billingPostCode = billingAddress[4];

    String? phoneCode, postCode, city, countryId, region, regionId;
    double? latitude, longitude;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          secondTitle: box.read("storeName"),
          title: "Checkout",
          icon: Icons.arrow_back_ios),
      body: Column(
        children: [
          Expanded(
            child: ListView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: TextInput(text1: "Delivery Address", size: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          // _buildMapWidget(width, context),
                          // height10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                          "images/05_CHECKOUT-14.png")),
                                  width5,
                                  SizedBox(
                                      width: 240,
                                      child: SizedBox(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text("$shippingArea"),
                                          Text("$shippingStreet"),
                                          // Text("$shippingCity"),
                                          Text("$shippingCity"),
                                          height5,
                                          Text(
                                              "PIN:$shippingPostCode\nPh :$shippingPhoneNumber"),
                                        ],
                                      ))
                                      // buildMapTextWidget(
                                      //   text: Provider.of<LocationButtonProvider>(context)
                                      //       .selected,
                                      //   maxLines: 3,
                                      // ),
                                      ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.all(8),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.pop(context, 1);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ScreenAddressBook(
                                                    isBasket: true)));
                                    ['shipping_address'];
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, top: 10),
                                    child: TextInput(
                                      text1: "Change",
                                      size: 15,
                                      colorOfText: primaryColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ]),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300)),
                    ),
                  ),
                  _buildCashWidget(),
                  _buildPaymentSummaryWidget(),
                  height10,
                  // _buildTermsAndConditionWidget(),
                  height20,
                ],
              ),
              height10
            ]),
          ),
          SizedBox(
            height: 60,
            width: (MediaQuery.of(context).size.width) - 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Consumer<ShipppingAddressConfirmProvider>(
                  builder: (context, valuee, child) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      if (box.read("token") != null) {
                        if (_site.name == "cashondelivery") {
                          await valuee.createOrder(method: "checkmo");
                          Future.delayed(const Duration(seconds: 3))
                              .then((value) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentSuccessDetailPage(
                                          entityId: valuee.orderIdString,
                                          whereisFrom: false,
                                          orderMethod: "CashOnDelivery",
                                        )));
                          });

                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              )),
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 550,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 120.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: primaryColor, width: 2),
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 60,
                                          color: Colors.green,
                                        ),
                                      ),
                                      height20,
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          TextInput(
                                              text1: "Thank you for",
                                              weight: FontWeight.bold,
                                              size: 16),
                                          TextInput(
                                              text1: "your ordering",
                                              weight: FontWeight.bold,
                                              size: 16),
                                          height20,
                                          TextInput(
                                              text1:
                                                  "Your order has been recieved.Sit back and relax",
                                              size: 13),
                                          TextInput(
                                              text1:
                                                  "You will recieve an update as notification",
                                              size: 13),
                                          TextInput(
                                              text1: "Once accepted by Cook",
                                              size: 13),
                                          height20,
                                          TextInput(
                                              text1:
                                                  "If not recived, you can contact seller from",
                                              size: 13),
                                          TextInput(
                                              text1: "My Order List", size: 13),
                                          // TextInput(text1: "${response.orderId}", size: 13),
                                          height20,
                                          TextInput(
                                              text1: "Order Something else",
                                              size: 13),
                                          height20,
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          await valuee.createOrder(method: "razorpay");

                          openCheckout(
                              orderId: box.read("orderId"),
                              price: (((valuee.checkoutCartList!.totals!
                                          .baseGrandTotal!) *
                                      (100))
                                  .toString()));
                        }
                      } else {
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
                                      child: const TextInput(
                                        text1: "Cancel",
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ScreenLoginPage()));
                                      },
                                      child: const Text("Login"))
                                ],
                              );
                            });
                      }
                    },
                    child: const TextInput(
                      text1: "Place order",
                      size: 18,
                    ));
              }),
            ),
          ),
          height20
        ],
      ),
    );
  }

  // Column _buildTermsAndConditionWidget() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.only(left: 10),
  //         child: TextInput(
  //           text1: "By placing this order you agree to the Credit Card",
  //           colorOfText: Colors.grey,
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 10),
  //         child: Row(
  //           children: [
  //             const TextInput(
  //               text1: "payment\t",
  //               colorOfText: Colors.grey,
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 launchInBrowser(Uri.parse(termsOfUseUrl));
  //               },
  //               child: const TextInput(
  //                 text1: "terms and conditions",
  //                 colorOfText: primaryColor,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Padding _buildPaymentSummaryWidget() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height10,
          const TextInput(
            text1: "Payment Summary",
            size: 20,
          ),
          height10,
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInput(
                        text1: "Sub Total",
                        size: 12,
                      ),
                      // height10,
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
                      height5,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextInput(
                            text1: "Grand Total",
                            size: 12,
                          ),
                          TextInput(
                            text1: "(Including VAT)",
                            size: 8,
                            colorOfText: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Consumer<ShipppingAddressConfirmProvider>(
                      builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextInput(
                          text1:
                              "₹ ${value.checkoutCartList?.totals?.subtotalInclTax?.toString()}",
                          size: 12,
                        ),
                        // height10,
                        TextInput(
                          text1:
                              "₹ ${value.checkoutCartList?.totals?.shippingAmount?.toString()}",
                          size: 12,
                          colorOfText: Colors.grey,
                        ),
                        height5,
                        height10,
                        TextInput(
                          text1:
                              "₹ ${value.checkoutCartList?.totals?.baseGrandTotal?.toString()}",
                          colorOfText: primaryColor,
                          size: 17,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          height40,
        ],
      ),
    );
  }

  PaymentMethod _site = PaymentMethod.cashondelivery;
  _buildCashWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20,
        // const Padding(
        //   padding: EdgeInsets.only(left: 10),
        //   child: Align(
        //       alignment: Alignment.topLeft,
        //       child: TextInput(
        //         text1: "Payment Method",
        //         size: 20,
        //       )),
        // ),
        // height10,
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Container(
        //     height: 50,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(color: Colors.grey.shade200)),
        //     child: Center(
        //       child: ListTile(
        //         title: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             const TextInput(text1: "Debit / Credit Card"),
        //             Padding(
        //               padding: const EdgeInsets.only(right: 10),
        //               child: SizedBox(
        //                   height: 25,
        //                   width: 25,
        //                   child: SvgPicture.asset("images/debit card.svg")),
        //             ),
        //           ],
        //         ),
        //         contentPadding: const EdgeInsets.symmetric(vertical: 0),
        //         visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        //         leading: Radio(
        //             fillColor: MaterialStateProperty.resolveWith<Color>(
        //                 (Set<MaterialState> states) =>
        //                     PaymentMethod.debitOrCredit == _site
        //                         ? primaryColor
        //                         : Colors.grey.shade200),
        //             value: PaymentMethod.debitOrCredit,
        //             groupValue: _site,
        //             onChanged: (PaymentMethod? value) {
        //               setState(() {
        //                 _site = value!;
        //               });
        //             }),
        //       ),
        //     ),
        //   ),
        // ),
        // height10,
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Container(
        //     height: 50,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(color: Colors.grey.shade200)),
        //     child: Center(
        //       child: ListTile(
        //         title: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             const TextInput(text1: "Google Pay"),
        //             Padding(
        //               padding: const EdgeInsets.only(right: 10),
        //               child: SizedBox(
        //                   height: 25,
        //                   width: 25,
        //                   child: SvgPicture.asset("images/g pay.svg")),
        //             ),
        //           ],
        //         ),
        //         contentPadding: const EdgeInsets.symmetric(vertical: 0),
        //         visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        //         leading: Radio(
        //             activeColor: Colors.grey,
        //             fillColor: MaterialStateProperty.resolveWith<Color>(
        //                 (Set<MaterialState> states) =>
        //                     PaymentMethod.googlepay == _site
        //                         ? primaryColor
        //                         : Colors.grey.shade200),
        //             value: PaymentMethod.googlepay,
        //             groupValue: _site,
        //             onChanged: (PaymentMethod? value) {
        //               setState(() {
        //                 _site = value!;
        //               });
        //             }),
        //       ),
        //     ),
        //   ),
        // ),
        // height10,
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Container(
        //     height: 50,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(color: Colors.grey.shade200)),
        //     child: Center(
        //       child: ListTile(
        //         title: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             const TextInput(text1: "Paytm"),
        //             Padding(
        //               padding: const EdgeInsets.only(right: 10),
        //               child: SizedBox(
        //                   height: 25,
        //                   width: 25,
        //                   child: SvgPicture.asset("images/paytm.svg")),
        //             ),
        //           ],
        //         ),
        //         contentPadding: const EdgeInsets.symmetric(vertical: 0),
        //         visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        //         leading: Radio(
        //             fillColor: MaterialStateProperty.resolveWith<Color>(
        //                 (Set<MaterialState> states) =>
        //                     PaymentMethod.paytm == _site
        //                         ? primaryColor
        //                         : Colors.grey.shade200),
        //             value: PaymentMethod.paytm,
        //             groupValue: _site,
        //             onChanged: (PaymentMethod? value) {
        //               setState(() {
        //                 _site = value!;
        //               });
        //             }),
        //       ),
        //     ),
        //   ),
        // ),
        // height10,
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Container(
        //     height: 50,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(color: Colors.grey.shade200)),
        //     child: Center(
        //       child: ListTile(
        //         title: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             const TextInput(text1: "Phonepe"),
        //             Padding(
        //               padding: const EdgeInsets.only(right: 10),
        //               child: SizedBox(
        //                   height: 25,
        //                   width: 25,
        //                   child: SvgPicture.asset("images/pe.svg")),
        //             ),
        //           ],
        //         ),
        //         contentPadding: const EdgeInsets.symmetric(vertical: 0),
        //         visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        //         leading: Radio(
        //             fillColor: MaterialStateProperty.resolveWith<Color>(
        //                 (Set<MaterialState> states) =>
        //                     PaymentMethod.phonepay == _site
        //                         ? primaryColor
        //                         : Colors.grey.shade200),
        //             value: PaymentMethod.phonepay,
        //             groupValue: _site,
        //             onChanged: (PaymentMethod? value) {
        //               setState(() {
        //                 _site = value!;
        //               });
        //             }),
        //       ),
        //     ),
        //   ),
        // ),
        // height10,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200)),
            child: Center(
              child: ListTile(
                // trailing: SvgPicture.asset("images/debit card.svg"),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextInput(text1: "Cash on Delivery"),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: SvgPicture.asset("images/cash.svg")),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: Radio(
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) =>
                            PaymentMethod.cashondelivery == _site
                                ? primaryColor
                                : Colors.grey.shade200),
                    value: PaymentMethod.cashondelivery,
                    groupValue: _site,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _site = value!;
                      });
                    }),
              ),
            ),
          ),
        ),
        height10
      ],
    );

    // Row(
    //   children: [
    //     Checkbox(
    //       value: value4,
    //       activeColor: primaryColor,
    //       onChanged: (value) {
    //         setState(() {
    //           value4 = value!;
    //         });
    //       },
    //     ),
    //     SizedBox(
    //         height: 30,
    //         width: 30,
    //         child: Image.asset("images/05_CHECKOUT-53.png")),
    //     width10,
    //     const TextInput(
    //       text1: "Cash",
    //       colorOfText: Colors.grey,
    //     )
    //   ],
    // );
  }

  Padding _buildContactlessDeliveryWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 227, 232, 236),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("images/05_CHECKOUT-39.png")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCommonTextWidgetForContactlessWidget(
                            weight: FontWeight.bold,
                            size: 15.00,
                            text: "Contactless delivery"),
                        _buildCommonTextWidgetForContactlessWidget(
                            text: "Leave order at doorstep and"),
                        _buildCommonTextWidgetForContactlessWidget(
                            text: "inform me"),
                        height10,
                        _buildCommonTextWidgetForContactlessWidget(
                            text: "Not applicable with cash payment",
                            color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Checkbox(
                      activeColor: Colors.white,
                      checkColor: primaryColor,
                      value: value1,
                      onChanged: (value) {
                        setState(() {
                          value1 = value!;
                        });
                      }))
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildDeliveryTimeSheduleWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                width10,
                SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset("images/28_PRODUCT DETAIL 2-60.png")),
                width10,
                const TextInput(
                  text1: "39 mins",
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: TextInput(
                text1: "Schedule",
                colorOfText: primaryColor,
              ),
            )
          ]),
        ),
      ),
    );
  }

  TextInput _buildCommonTextWidgetForContactlessWidget(
      {text, size = 12.00, color = Colors.black, weight = FontWeight.normal}) {
    return TextInput(
      text1: text,
      size: size,
      colorOfText: color,
      weight: weight,
    );
  }

  Container _buildMapWidget(double width, BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: width,
      height: 90,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  height: 150,
                  width: MediaQuery.of(context).size.width - 20,
                  child: MapMyWidget(
                    mapbutton: false,
                    latitude: 0,
                    longitude: 0,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Padding rowWidget({firstContent, lastContent}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInput(text1: firstContent),
          TextInput(text1: lastContent)
        ],
      ),
    );
  }

  buildMapTextWidget({text, color, int? maxLines}) {
    return TextInput(
      text1: text,
      size: 12,
      colorOfText: color,
      maxLines: maxLines,
    );
  }
}



// Request Params

// {
// 	"name": "",
// 	"email": "",
// 	"phone": "",
// 	"subject": "",
// 	"message": ""
// }

// Resp Data


// {
// 	"status": 1,
// 	"code": 0,
// 	"message": "Message sent successfully",
// 	"data": []
// }

