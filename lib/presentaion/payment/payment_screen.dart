import 'package:fazzmi/core/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../widgets/leading_app_bar.dart';
import '../../widgets/textInput.dart';

class ScreenPayment extends StatelessWidget {
  const ScreenPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarLeading(
        widget: SizedBox(
            height: 50,
            child: Image.asset(
              "images/Fazzmi_logo.png",
              fit: BoxFit.fill,
            )),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 150,
                width: 200,
                child: Image.asset("images/save-card.png")),
            height10,
            const TextInput(
                text1: "You don't have any saved",
                weight: FontWeight.bold,
                size: 20),
            const TextInput(
              text1: "payment methods",
              size: 20,
              weight: FontWeight.bold,
            ),
            height10,
            const TextInput(
              text1: "Add these in at checkout for a smoother",
              colorOfText: Colors.grey,
            ),
            const TextInput(
              text1: "experience",
              colorOfText: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
