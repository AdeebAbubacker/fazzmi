import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/my_account/myProfile/editProfile/profile_edit_screen.dart';
import 'package:fazzmi/presentaion/my_account/myProfile/changepassword/screenchangePassword.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/textInput.dart';

class ScreenMyProfile extends StatefulWidget {
  const ScreenMyProfile({Key? key}) : super(key: key);

  @override
  State<ScreenMyProfile> createState() => _ScreenMyProfileState();
}

class _ScreenMyProfileState extends State<ScreenMyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            const CustomAppBar(title: "My Profile", icon: Icons.arrow_back_ios),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height10,
                Align(
                  alignment: Alignment.topLeft,
                  child: Consumer<CartCounterStore>(
                      builder: (context, value, child) {
                    if (!value.loader2) {
                      return Row(
                        children: [
                          TextInput(
                            text1: value.profileDataList!.firstname!,
                            colorOfText: Colors.black,
                            size: 25,
                          ),
                          width10,
                          TextInput(
                            text1: value.profileDataList!.lastname!,
                            colorOfText: Colors.black,
                            size: 25,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Consumer<CartCounterStore>(
                      builder: (context, value, child) {
                    if (!value.loader2) {
                      return TextInput(
                        text1: value.profileDataList!.email!,
                        colorOfText: Colors.grey,
                        size: 13,
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                ),
                height20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextInput(
                      text1: "GENERAL INFORMATION",
                      colorOfText: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenEdit()));
                      },
                      child: const TextInput(
                        text1: "Edit",
                        colorOfText: primaryColor,
                        size: 15,
                      ),
                    )
                  ],
                ),
                height20,
                height10,
                const Align(
                  alignment: Alignment.topLeft,
                  child: TextInput(
                    text1: "First Name",
                    colorOfText: Colors.grey,
                    size: 14,
                  ),
                ),
                height10,
                Align(
                  alignment: Alignment.topLeft,
                  child: Consumer<CartCounterStore>(
                      builder: (context, value, child) {
                    if (!value.loader2) {
                      return TextInput(
                          text1: value.profileDataList!.firstname!,
                          colorOfText: Colors.black,
                          size: 20);
                    } else {
                      return const SizedBox();
                    }
                  }),
                ),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                ),
                height20,
                const Align(
                  alignment: Alignment.topLeft,
                  child: TextInput(
                    text1: "Last Name",
                    colorOfText: Colors.grey,
                    size: 14,
                  ),
                ),
                height10,
                Align(
                  alignment: Alignment.topLeft,
                  child: Consumer<CartCounterStore>(
                      builder: (context, value, child) {
                    if (!value.loader2) {
                      return TextInput(
                        text1: value.profileDataList!.lastname!,
                        colorOfText: Colors.black,
                        size: 20,
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                ),
                const Divider(
                  endIndent: 5,
                  indent: 5,
                ),
                height20,
                // const Align(
                //   alignment: Alignment.topLeft,
                //   child: TextInput(
                //     text1: "Recieve Communications in",
                //     colorOfText: Colors.grey,
                //     size: 14,
                //   ),
                // ),
                // height10,
                // const Align(
                //   alignment: Alignment.topLeft,
                //   child: TextInput(
                //     text1: "English",
                //     colorOfText: Colors.black,
                //     size: 20,
                //   ),
                // ),
                // const Divider(
                //   endIndent: 5,
                //   indent: 5,
                // ),
                // height40,
                const Align(
                  alignment: Alignment.topLeft,
                  child: TextInput(
                    text1: "SECURITY INFORMATION",
                    colorOfText: Colors.grey,
                    size: 14,
                  ),
                ),
                height20,
                height10,
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: primaryColor),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenchangePassword()));
                      },
                      child: const TextInput(
                        text1: "Change Password",
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
