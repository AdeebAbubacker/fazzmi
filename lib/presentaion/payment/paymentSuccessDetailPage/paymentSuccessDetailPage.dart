import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/mainPage/screen_main_page.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/customButton2.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/commonMethods.dart';
import '../../../provider/paymentSuccessProvider.dart';

class PaymentSuccessDetailPage extends StatefulWidget {
  const PaymentSuccessDetailPage(
      {Key? key,
      this.entityId,
      required this.orderMethod,
      required this.whereisFrom})
      : super(key: key);

  final String orderMethod;
  final bool whereisFrom;
  final String? entityId;

  @override
  State<PaymentSuccessDetailPage> createState() =>
      _PaymentSuccessDetailPageState();
}

class _PaymentSuccessDetailPageState extends State<PaymentSuccessDetailPage> {
  var box = GetStorage();

  fncDownloadInvoice() async {
    // var token = boxtoken;
    // var orderId = box.read("orderId");

    var data = await http.get(
        Uri.parse(
            "https://staging.fazzmi.com/rest/V1/fazmmi-apis/getinvoicepdf/${widget.entityId}"),
        headers: {
          'Authorization': 'Bearer yajlqqlju6uewudbb5vudmt7swwp5041',
          'Cookie':
              'PHPSESSID=2cc4v9d5fvgkhd9edvptgr7c03; mage-messages=%5B%7B%22type%22%3A%22error%22%2C%22text%22%3A%22Invalid%20Form%20Key.%20Please%20refresh%20the%20page.%22%7D%2C%7B%22type%22%3A%22error%22%2C%22text%22%3A%22Invalid%20Form%20Key.%20Please%20refresh%20the%20page.%22%7D%5D; private_content_version=2764eab55f551dd2cc18e0765d0bacbf'
        });

    final permission = await Permission.storage.request();
    // String fileName = 'inv_fazzmi_' +
    // DateTime.now().millisecond.toString().replaceAll(" ", "");
    if (permission.isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      final pdfpath = File('${directory.path}/receipt.pdf');
      pdfpath.writeAsBytesSync(data.bodyBytes); // add http response.bodyBytes
      await Share.shareXFiles([XFile(pdfpath.path)]);
      setState(() {
        loader = true;
      });

      // final id = await FlutterDownloader.enqueue(
      //   url:
      //       "https://staging.fazzmi.com/rest/V1/fazmmi-apis/getinvoicepdf/$orderId",
      //   savedDir: externalDir!.path,
      //   headers: _setHeaders(),
      //   showNotification: true,
      //   openFileFromNotification: true,

      //   //'/storage/emulated/0/Download',
      //   fileName: fileName,
      // );
    } else {}
  }

  ReceivePort _receivePort = ReceivePort();
  int progress = 0;
  bool loader = true;

  @override
  void initState() {
    loadData();

    IsolateNameServer.registerPortWithName(_receivePort.sendPort, 'download');
    _receivePort.listen((data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      progress = data[2];
      if (status.toString() == "DownloadTaskStatus(3)") {
        // Toast.show("Invoice downloaded!", duration: 1, gravity: Toast.bottom);
        FlutterDownloader.open(taskId: id);
      } else {}
    });
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<PaymentSuccessPageProvider>(context, listen: false)
          .getPaymentSuccessDetails(
              commigfrom: widget.whereisFrom, entityId: widget.entityId);
    });
  }

  static downloadCallback(id, status, progress) {
    final SendPort? sendPort = IsolateNameServer.lookupPortByName('download');
    sendPort!.send([id, status, progress]);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('download');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var box = GetStorage();
    // var shippingAddress = box.read("shippingAddress");
    // var billingAddress = box.read("billingAddress");
    // // var shippingbuilding = shippingAddress[11];
    // var shippingStreet = shippingAddress[6];
    // var shippingPhoneNumber = shippingAddress[9];
    // var shippingPhoneNumber = shippingAddress[9];
    // var shippingState = shippingAddress[0];
    // var shippingPostCode = shippingAddress[4];
    // var billingPhoneNumber = billingAddress[9];
    // var billingState = billingAddress[0];
    // // var billingCountry = billingAddress[3];
    // var billingPostCode = billingAddress[4];

    ToastContext().init(context);
    return WillPopScope(
      onWillPop: () async => widget.whereisFrom,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            icon: widget.whereisFrom == true ? Icons.arrow_back_ios_new : null,
            appbarleadingFunction: () {
              widget.whereisFrom == true ? Navigator.pop(context) : "";
            },
            title: "View Order Details"),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Consumer<PaymentSuccessPageProvider>(
                    builder: (context, value, child) {
                  if (!value.paymentLoader) {
                    var data = value.paymentSuccesList!.data;
                    return ListView(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextInput(
                                            text1: "Order Date",
                                            colorOfText: Colors.grey),
                                        TextInput(
                                            text1: "Order Id",
                                            colorOfText: Colors.grey),
                                        TextInput(
                                            text1: "Order Total",
                                            colorOfText: Colors.grey)
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        TextInput(
                                            text1:
                                                "${data![0].createdAt!.day} - ${data[0].createdAt!.month} - ${data[0].createdAt!.year}",
                                            colorOfText: Colors.black),
                                        TextInput(
                                            text1: "${data[0].orderId}",
                                            colorOfText: Colors.black),
                                        TextInput(
                                            text1:
                                                "₹ ${double.parse(data[0].grandTotal!).toStringAsFixed(2)}",
                                            colorOfText: Colors.black)
                                      ],
                                    ),
                                  ],
                                ),
                                height5,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const TextInput(
                                      text1: "Download Invoice",
                                      weight: FontWeight.bold,
                                    ),
                                    widget.orderMethod == "Razorpay"
                                        ? loader
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.grey,
                                                  size: 15,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    loader = false;
                                                  });
                                                  fncDownloadInvoice();
                                                  // setState(() {
                                                  //   loader = true;
                                                  // });
                                                },
                                              )
                                            : const CircularProgressIndicator()
                                        : const TextInput(
                                            text1: "Pending",
                                            colorOfText: primaryColor,
                                          )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        height10,
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextInput(
                            text1: "Shipping details",
                            weight: FontWeight.bold,
                            size: 16,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const Padding(
                                //   padding: EdgeInsets.symmetric(vertical: 12),
                                // child:
                                //     TextInput(text1: "Fazzmi Day Delivery"),
                                // ),
                                // const Divider(),
                                TextInput(
                                  text1: data[0].status!,
                                  weight: FontWeight.bold,
                                ),
                                const TextInput(text1: "Delivery Estimate"),
                                TextInput(
                                  text1: deliveryDataConversion(DateTime.parse(
                                      data[0].items![0].delivery_date!)),
                                  colorOfText: primaryColor,
                                ),
                                height10,
                                Consumer<PaymentSuccessPageProvider>(
                                    builder: (context, value, child) {
                                  if (!value.paymentLoader) {
                                    return Column(
                                        children: List.generate(
                                            data[0].items!.length,
                                            (index) => DeliveryProducts(
                                                  image: data[0]
                                                      .items![index]
                                                      .image!,
                                                  productName: data[0]
                                                      .items![index]
                                                      .name!,
                                                  qty: data[0]
                                                      .items![index]
                                                      .qty!
                                                      .toString(),
                                                  storeName:
                                                      data[0].stores![0].name!,
                                                  total: data[0]
                                                      .items![index]
                                                      .total!,
                                                )));
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                                // const Divider(),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     const TextInput(
                                //       size: 12,
                                //       text1: "Track Shipment",
                                //       weight: FontWeight.bold,
                                //     ),
                                //     IconButton(
                                //         onPressed: () {},
                                //         icon: const Icon(
                                //           Icons.arrow_forward_ios,
                                //           color: Colors.grey,
                                //           size: 15,
                                //         ))
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                        height10,
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: TextInput(
                            text1: "Payment Information",
                            weight: FontWeight.bold,
                            size: 16,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              )),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextInput(
                                        text1: "Payment Method",
                                        weight: FontWeight.bold,
                                      ),
                                      TextInput(
                                        text1: data[0].payment_method!,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                        height10,
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextInput(
                            text1: "Billing Address",
                            weight: FontWeight.bold,
                            size: 16,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height5,
                                TextInput(
                                  weight: FontWeight.w600,
                                  text1:
                                      "${data[0].billingAddress?.firstname} ${data[0].billingAddress?.lastname}",
                                ),
                                TextInput(
                                  colorOfText: Colors.grey,
                                  // text1: "$shippingStreet",
                                  text1: "${data[0].billingAddress?.street}",
                                ),
                                TextInput(
                                  colorOfText: Colors.grey,
                                  //  text1: "$shippingCity",
                                  text1: "${data[0].billingAddress?.city}",
                                ),
                                TextInput(
                                  colorOfText: Colors.grey,
                                  text1:
                                      "Pin : ${data[0].billingAddress?.postcode}",
                                ),
                                TextInput(
                                  colorOfText: Colors.grey,
                                  text1:
                                      "Ph : ${data[0].billingAddress?.telephone}",
                                ),
                              ],
                            ),
                          ),
                        ),
                        height10,
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextInput(
                            text1: "Shipping Address",
                            weight: FontWeight.bold,
                            size: 16,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // height5,
                                TextInput(
                                  weight: FontWeight.w600,
                                  text1:
                                      "${data[0].shippingAddress!.firstname!} ${data[0].shippingAddress!.lastname!}",
                                ),
                                height5,
                                TextInput(
                                  colorOfText: Colors.grey,
                                  text1:
                                      // "$shippingbuilding"
                                      "${data[0].shippingAddress!.street!},\n${data[0].shippingAddress!.city!}",
                                  // text1: "${data[0].shippingAddress!.building}",
                                ),
                                Visibility(
                                  visible:
                                      (data[0].shippingAddress!.city!) == true,
                                  child: TextInput(
                                      colorOfText: Colors.grey,
                                      text1:
                                          "${data[0].shippingAddress!.region}"
                                      //  "${data[0].shippingAddress!.region!}",
                                      ),
                                ),
                                TextInput(
                                  colorOfText: Colors.grey,
                                  text1:
                                      "Pin : ${data[0].shippingAddress!.postcode!}",
                                ),
                                TextInput(
                                  colorOfText: Colors.grey,
                                  text1:
                                      "Ph : ${data[0].shippingAddress!.telephone!}",
                                ),
                              ],
                            ),
                          ),
                        ),
                        height10,
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextInput(
                            text1: "Order Summary",
                            weight: FontWeight.bold,
                            size: 16,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                builldOrderRowWidget(
                                    key: "Item Count",
                                    value: "${data[0].itemCount}"),
                                // builldOrderRowWidget(
                                //     key: "Postage & Packing", value: "₹1,2019.00"),
                                // builldOrderRowWidget(
                                //     key: "GST",
                                //     value:
                                //         "₹ ${double.parse(data[0].taxAmount!).toStringAsFixed(2)}"),
                                builldOrderRowWidget(
                                    key: "Total",
                                    value:
                                        "₹ ${double.parse(data[0].subtotalInclTax!).toStringAsFixed(2)}"),
                                builldOrderRowWidget(
                                    key: "Delivery charge",
                                    value:
                                        "₹ ${double.parse(data[0].shippingAmount!).toStringAsFixed(2)}"),

                                height10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const TextInput(
                                      text1: "Order Total",
                                      colorOfText: primaryColor,
                                    ),
                                    TextInput(
                                      text1:
                                          "₹ ${double.parse(data[0].grandTotal!).toStringAsFixed(2)}",
                                      colorOfText: primaryColor,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        height10,
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            ),
            if (!widget.whereisFrom)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<CartCounterStore>(
                    builder: (context, cartValue, child) {
                  return CustomButton2(
                    buttonName: 'Continue Shopping',
                    buttonAction: () {
                      cartValue.getCartProductDetailsLogin();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ScreenMainPage()),
                          (Route<dynamic> route) => false);
                    },
                    color: primaryColor,
                    height: 60,
                    width: MediaQuery.of(context).size.width - 20,
                    textColor: Colors.white,
                  );
                }),
              ),
            height10
          ],
        ),
      ),
    );
  }

  Row builldOrderRowWidget({key, value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [TextInput(text1: key), TextInput(text1: value)],
    );
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    ToastContext().init(context);
    return Toast.show(msg, duration: duration, gravity: gravity);
  }
}

class DeliveryProducts extends StatelessWidget {
  final String qty, storeName, total, image, productName;
  const DeliveryProducts({
    Key? key,
    required this.qty,
    required this.storeName,
    required this.total,
    required this.image,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var totals = double.parse(total).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) => Center(
                child: Image.asset(
                    height: 60, width: 60, "images/Fazzmi_logo.png")),
            image,
            width: 50,
            height: 60,
          ),
          width10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: TextInput(
                  maxLines: 2,
                  text1: productName,
                  weight: FontWeight.bold,
                ),
              ),
              TextInput(text1: "Qty: $qty"),
              // TextInput(text1: "Sold By $storeName"),
            ],
          ),
          width20,
          Padding(
            padding: const EdgeInsets.only(left: 33.0),
            child: TextInput(text1: "₹ $totals"),
          )
        ],
      ),
    );
  }
}
