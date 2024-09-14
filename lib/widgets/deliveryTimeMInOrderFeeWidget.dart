import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';

class DeliveryTimeMInOrderFeeWidget extends StatelessWidget {
  const DeliveryTimeMInOrderFeeWidget({
    Key? key,
    required this.deliverydate,
    required this.minOrder,
    this.deliveryfee,
  }) : super(key: key);
  final String deliverydate, minOrder;
  final String? deliveryfee;

  // loadData() {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextInput(
                text1: deliverydate,
                colorOfText: Colors.black,
                size: 15,
              ),
              const TextInput(
                text1: "Delivery",
                colorOfText: Colors.grey,
                size: 11,
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: VerticalDivider(
              thickness: 1,
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: const [
          //     // TextInput(
          //     //   text1:
          //     //       "₹ ${value.deliveryfee!.baseAmount!.toString()}" ?? "",
          //     //   colorOfText: Colors.black,
          //     //   size: 15,
          //     // ),
          //     TextInput(
          //       text1: "Delivery Fee",
          //       colorOfText: Colors.grey,
          //       size: 11,
          //     )
          //   ],
          // ),
          // const VerticalDivider(
          //   thickness: 1,
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextInput(
                text1: "₹ $minOrder",
                colorOfText: Colors.black,
                size: 15,
              ),
              const TextInput(
                text1: "Min Order",
                colorOfText: Colors.grey,
                size: 11,
              )
            ],
          ),
        ],
      ),
    );
  }
}
