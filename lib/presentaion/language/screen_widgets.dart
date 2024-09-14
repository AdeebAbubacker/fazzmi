import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/textInput.dart';

class ScreenLanguage extends StatelessWidget {
  const ScreenLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          title: "Select Language", icon: Icons.arrow_back_ios),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        height40,
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextInput(
            text1: "Pick your language",
            size: 20,
          ),
        ),
        height10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: (MediaQuery.of(context).size.width / 3) - 15,
              width: (MediaQuery.of(context).size.width / 3) - 15,
              color: primaryColor,
              child: const Center(
                  child: TextInput(
                text1: "ENGLISH",
                size: 18,
                colorOfText: Colors.white,
              )),
            ),
            Container(
              height: (MediaQuery.of(context).size.width / 3) - 15,
              width: (MediaQuery.of(context).size.width / 3) - 15,
              color: primaryColor,
              child: const Center(
                  child: TextInput(
                text1: "हिन्दी",
                size: 18,
                colorOfText: Colors.white,
              )),
            ),
            Container(
              height: (MediaQuery.of(context).size.width / 3) - 15,
              width: (MediaQuery.of(context).size.width / 3) - 15,
              color: primaryColor,
              child: const Center(
                  child: TextInput(
                text1: "മലയാളം",
                size: 18,
                colorOfText: Colors.white,
              )),
            ),
          ],
        ),
        height10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: (MediaQuery.of(context).size.width / 3) - 15,
              width: (MediaQuery.of(context).size.width / 3) - 15,
              color: primaryColor,
              child: const Center(
                  child: TextInput(
                text1: "عربى",
                size: 18,
                colorOfText: Colors.white,
              )),
            ),
            Container(
              height: (MediaQuery.of(context).size.width / 3) - 15,
              width: (MediaQuery.of(context).size.width / 3) - 15,
              color: primaryColor,
              child: const Center(
                  child: TextInput(
                text1: "தமிழ்",
                size: 18,
                colorOfText: Colors.white,
              )),
            ),
            Container(
              height: (MediaQuery.of(context).size.width / 3) - 15,
              width: (MediaQuery.of(context).size.width / 3) - 15,
              color: primaryColor,
              child: const Center(
                  child: TextInput(
                text1: "ಕನ್ನಡ",
                size: 18,
                colorOfText: Colors.white,
              )),
            ),
          ],
        ),
      ]),
    );
  }
}
