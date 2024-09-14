import 'package:fazzmi/presentaion/delivery_location/screenPinLocation.dart';
import 'package:fazzmi/presentaion/mainPage/screen_main_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/constants/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/textInput.dart';

class ScreenStartingPage extends StatelessWidget {
  final box = GetStorage();
  
  ScreenStartingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/splash.png'))),
                width: MediaQuery.of(context).size.width,
                height: height / 1.4,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: TextInput(
                          size: 22,
                          text1:
                              "Fazzmi works best when we \n     know where to deliver.",
                        ),
                      ),
                      const TextInput(
                        size: 15,
                        text1:
                            "If we have the location, we can do a better\n   job to find what you want and deliver it.",
                      ),
                      CustomButton(
                        color: primaryColor,
                        width: width - 50,
                        buttonName: "Continue",
                        customButton: () {
                          if (box.read('locationValue') == null ||
                              box.read('locationValue') == '') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PinLocationScreen()));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScreenMainPage()));
                          }

                          // ScreenMainPage()));
                        },
                      )
                    ],
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    ),
                  ),
                  width: width,
                  height: height / 3.1,
                ),
              ),
              // Positioned(
              //   bottom: height / 1.7 / .999,
              //   top: height / 3.3,
              //   right: width / 3.1,
              //   left: width / 3.1,
              //   child: Container(
              //     decoration: const BoxDecoration(
              //         image: DecorationImage(
              //             fit: BoxFit.fill,
              //             image:
              //                 AssetImage('images/starting_page_zz_icon.png'))),
              //   ),
              // ),
              // Positioned(
              //     bottom: height / 1.7,
              //     top: height / 3,
              //     right: width / 3.8,
              //     left: width / 3.8,
              //     child: const TextInput(
              //       text1: "Best Offers",
              //       colorOfText: Colors.white,
              //       size: 33,
              //       weight: FontWeight.bold,
              //     )),
            ],
          ),
        ),
      ),
    ));
  }
}
