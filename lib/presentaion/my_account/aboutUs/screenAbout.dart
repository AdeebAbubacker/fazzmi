import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/core/constants/urls.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/commonMethods.dart';
import '../../../widgets/Custom_inkWell.dart';

class ScreenAbout extends StatelessWidget {
  const ScreenAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "About APP",
        icon: Icons.arrow_back_ios,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            height10,
            buildbuttonWidget(
                name: "FAQs",
                Function: () {
                  launchInBrowser(Uri.parse(aboutUsUrl));
                }),
            // height40,
            buildbuttonWidget(
                name: "Privacy policy",
                Function: () {
                  launchInBrowser(Uri.parse(privacyPolicyUrl));
                }),
            buildbuttonWidget(
                Function: () {
                  launchInBrowser(Uri.parse(termsOfUseUrl));
                },
                name: "Terms and Conditions"),
            buildbuttonWidget(
                Function: () {
                  launchInBrowser(Uri.parse(facebookUrl));
                },
                name: "Facebook"),
            buildbuttonWidget(
                Function: () {
                  launchInBrowser(Uri.parse(twiterUrl));
                },
                name: "Twitter"),
            buildbuttonWidget(
                Function: () {
                  launchInBrowser(Uri.parse(instaUrl));
                },
                name: "Instagram"),
            height40,
            height40,
            height40,
            height40,
            height40,

            height40,
            const TextInput(text1: "Version 8.96(1094)"),
            height5,
            // const Divider()
          ],
        ),
      ),
    );
  }

  Column buildbuttonWidget({name, Function()?}) {
    return Column(
      children: [
        CustomInkWell(
          onTap: Function,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextInput(
                text1: name,
                size: 17,
              ),
              CustomInkWell(
                  onTap: Function,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: Colors.grey,
                  ))
            ],
          ),
        ),
        const Divider(),
        height20,
        height5,
      ],
    );
  }
}
