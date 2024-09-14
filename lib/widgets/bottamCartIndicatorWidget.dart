import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/constants.dart';
import '../presentaion/shopping_folder/screen_shopping_basket.dart';
import '../presentaion/store/widgets/bottomCartContainerWidget.dart';

class BottamCartIndicatorWidget extends StatefulWidget {
  const BottamCartIndicatorWidget({
    Key? key,
    required this.storeName,
  }) : super(key: key);
  final String storeName;

  @override
  State<BottamCartIndicatorWidget> createState() =>
      _BottamCartIndicatorWidgetState();
}

class _BottamCartIndicatorWidgetState extends State<BottamCartIndicatorWidget> {
  @override
  Widget build(BuildContext context) {
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
                        builder: ((context) =>
                            ScreenShoppingBasket(storeName: widget.storeName)),
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
}
