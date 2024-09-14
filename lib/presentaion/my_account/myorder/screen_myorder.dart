import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/provider/myOrderProvider.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/commonMethods.dart';
import '../../../widgets/textInput.dart';
import '../../payment/paymentSuccessDetailPage/paymentSuccessDetailPage.dart';

class ScreenMyorders extends StatefulWidget {
  const ScreenMyorders({Key? key}) : super(key: key);
  @override
  State<ScreenMyorders> createState() => _ScreenMyordersState();
}

class _ScreenMyordersState extends State<ScreenMyorders> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<MyOrderProvider>(context, listen: false)
          .getMyorderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color colordivider = Color(int.parse('EEEEEE', radix: 16)).withOpacity(1.0);
    return Scaffold(
      appBar:
          const CustomAppBar(title: "My Orders", icon: Icons.arrow_back_ios),
      backgroundColor: Colors.white,
      body: Consumer<MyOrderProvider>(builder: (context, value, child) {
        if (!value.myOrderloader) {
          if (value.myOrderList!.data!.isNotEmpty) {
            var data = value.myOrderList!.data;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                      children: List.generate(
                          data!.length,
                          (index) => Column(
                                children: [
                                  orderFromWidget(
                                      entityId: data[index].entityId,
                                      date:
                                          "Placed on ${deliveryDataConversion(data[index].createdAt!)}",
                                      storeName: data[index].stores![0].name),
                                  width10,
                                  Column(
                                    children: List.generate(
                                      data[index].items!.length,
                                      (indexx) => rowWidgetMyorder(
                                          image:
                                              data[index].items![indexx].image,
                                          name1:
                                              data[index].items![indexx].name,
                                          name2:
                                              data[index].items![indexx].store,
                                          name3: data[index].status,
                                          color: Colors.green),
                                    ),
                                  ),
                                  Divider(
                                    color: colordivider,
                                    thickness: 1,
                                  ),
                                ],
                              ))),
                ),
              ],
            );
          } else {
            return const Center(child: TextInput(text1: "No Orders Found...."));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  Padding rowWidgetMyorder({image, name1, name2, name3, color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Image.network(
              image,
              fit: BoxFit.fill,
              errorBuilder: ((context, error, stackTrace) {
                return Image.asset(
                    fit: BoxFit.fill,
                    height: 90,
                    width: 70,
                    "images/Fazzmi_logo.png");
              }),
            ),
          ),
          width10,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: TextInput(
                  maxLines: 2,
                  text1: name1,
                  colorOfText: Colors.grey,
                ),
              ),
              TextInput(
                text1: capitalizeAllWord(name3),
                colorOfText: color,
              )
            ],
          )
        ],
      ),
    );
  }

  Padding orderFromWidget({storeName, date, entityId}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const TextInput(text1: "Order from"),
                  width5,
                  TextInput(
                    text1: storeName,
                    colorOfText: primaryColor,
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentSuccessDetailPage(
                                entityId: entityId,
                                orderMethod: "Razorpay",
                                whereisFrom: true,
                              )));
                },
                child: Row(
                  children: const [
                    TextInput(text1: "View Details", colorOfText: primaryColor),
                    width5,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: primaryColor,
                    )
                  ],
                ),
              )
            ],
          ),
          Align(
              alignment: Alignment.topLeft,
              child: TextInput(
                text1: date,
                colorOfText: Colors.grey,
              ))
        ],
      ),
    );
  }
}
