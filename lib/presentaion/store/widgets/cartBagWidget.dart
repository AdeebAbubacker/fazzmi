import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';

import '../../shopping_folder/screen_shopping_basket.dart';

class WidgetCartBag extends StatelessWidget {
  const WidgetCartBag({super.key, required this.storename, this.cartCount = 0});
  final String storename;
  final int cartCount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          TextInput(
            text1: cartCount.toString(),
            size: 12,
            colorOfText: primaryColor,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) =>
                      ScreenShoppingBasket(storeName: storename)),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
