import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';

class WidgetBottomCart extends StatelessWidget {
  const WidgetBottomCart({
    super.key,
    this.isApptheme = true,
    this.count,
    this.price,
    this.onTap,
    // this.specialPrice,
  });
  final bool isApptheme;
  // final double? specialPrice;
  final int? count;
  final double? price;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // double acctualPrice = double.parse(price.replaceAll('+', ''));
    // double offerPrice = double.parse(specialPrice.replaceAll('+', ''));
    double width = MediaQuery.of(context).size.width - 30;
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: isApptheme
            ? Border.all(color: Colors.black)
            : Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        color: isApptheme ? Colors.white : primaryColor,
      ),
      child: Row(
        children: [
          buildCountWidget(),
          const SizedBox(width: 15),
          buildPriceWidget(),
          buildActionWidget()
        ],
      ),
    );
  }

  Widget buildActionWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: onTap,
          child: TextInput(
            text1: "View Basket",
            size: 17,
            colorOfText: isApptheme ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildPriceWidget() {
    return TextInput(
      text1: "₹ $price",
      // text1: "₹ ${offerPrice == 0 ? acctualPrice : offerPrice}",
      size: 15,
      colorOfText: isApptheme ? Colors.black : Colors.white,
    );
  }

  Widget buildCountWidget() {
    return Container(
      height: 25,
      width: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isApptheme ? Colors.black : Colors.white),
      ),
      child: TextInput(
        text1: "$count",
        colorOfText: isApptheme ? Colors.black : Colors.white,
      ),
    );
  }
}
