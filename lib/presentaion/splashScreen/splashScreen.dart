import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/mainPage/screen_main_page.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

import '../../services/api_services.dart';
import '../startingpage/screen_starting_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5)).then((value) async {
      // await Provider.of<CartCounterStore>(context, listen: false)
      //     .getDeliveryFee();

      List<String> fazzmiAvailableAreas = [];
      box.write("fazzmiAvailableAreas", fazzmiAvailableAreas);

      if (box.read("token") == null && box.read("quoteIdGuest") == null) {
        await Provider.of<CartCounterStore>(context, listen: false)
            .guestUsers();
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenStartingPage(),
            ));
      } else {
        if (box.read('actualpinCode') == null ||
            box.read('actualpinCode') == '') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenStartingPage(),
              ));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ScreenMainPage()));
        }
        // try {
          
        // } catch (e) {
          
        // }
      }
    });
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SizedBox(
                  child: Image.asset(
                "images/Fazzmi_logo.png",
                height: 150,
                width: 250,
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: JumpingDotsProgressIndicator(
              color: primaryColor,
              fontSize: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
