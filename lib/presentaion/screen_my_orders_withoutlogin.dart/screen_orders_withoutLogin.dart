import 'package:fazzmi/presentaion/login/login_email/screen_login_email.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/customButton2.dart';
import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../widgets/textInput.dart';

class ScreenOrdersWithoutLogin extends StatefulWidget {
  const ScreenOrdersWithoutLogin({Key? key}) : super(key: key);

  @override
  State<ScreenOrdersWithoutLogin> createState() =>
      _ScreenOrdersWithoutLoginState();
}

class _ScreenOrdersWithoutLoginState extends State<ScreenOrdersWithoutLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Your Orders",
        icon: Icons.arrow_back_ios,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.baby_changing_station_sharp,
              color: Color.fromARGB(255, 203, 200, 200),
              size: 100,
            ),
            const TextInput(
              text1: "Orders",
              colorOfText: Colors.black,
              size: 20,
            ),
            height10,
            const TextInput(
              text1: "Log in to see your orders",
              colorOfText: Colors.grey,
              size: 13,
            ),
            height20,
            height10,
            CustomButton2(
              buttonAction: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenLoginEmail()));
              },
              buttonName: "Log in",
              height: 60,
              width: MediaQuery.of(context).size.width - 30,
              color: primaryColor,
              textColor: Colors.white,
              textSize: 20,
            ),
            height40,
            height40
          ],
        ),
      ),
    );
  }
}
