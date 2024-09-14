import 'package:fazzmi/core/constants/commonMethods.dart';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/core/constants/urls.dart';
import 'package:fazzmi/presentaion/my_account/aboutUs/screenAbout.dart';
import 'package:fazzmi/presentaion/my_account/addressbook/screen_addressbook.dart';
import 'package:fazzmi/presentaion/my_account/security/security_settings.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../widgets/customButton2.dart';
import '../../widgets/textInput.dart';
import '../../widgets/tittle_app_bar.dart';
import '../login/login_page/screen_login.dart';
import '../mainPage/widgets/bottam_nav.dart';
import '../screen_my_orders_withoutlogin.dart/screen_orders_withoutLogin.dart';
// import '../Notifications/screen_notifications.dart';
import 'favorite/screen_favorite.dart';
import 'myProfile/screen_my_profile.dart';
import 'myorder/screen_myorder.dart';

class ScreenMyAccount extends StatefulWidget {
  ScreenMyAccount({Key? key}) : super(key: key);
  final box = GetStorage();

  @override
  State<ScreenMyAccount> createState() => _ScreenMyAccountState();
}

class _ScreenMyAccountState extends State<ScreenMyAccount> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CartCounterStore>(context, listen: false)
          .getProfileData(token: box.read("token"));
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    DateTime pre_backpress = DateTime.now();
    return WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);

          final cantExit = timegap >= Duration(seconds: 2);

          pre_backpress = DateTime.now();

          if (cantExit) {
            //show snackbar
            final snack = SnackBar(
              content: Text('Press Back button again to Exit'),
              duration: Duration(seconds: 2),
            );

            ScaffoldMessenger.of(context).showSnackBar(snack);

            return false; // false will do nothing when back press
          } else {
            return true; // true will exit the app
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const TittleAppBar(title: "My Account"),
          body: Consumer<CartCounterStore>(builder: (context, value, child) {
            if (!value.loader2) {
              return ListView(
                children: [
                  height10,
                  value.box.read("token") == null
                      ? buildNotLoginedWidget(context)
                      : buildLoginedWidget(width),
                  Column(
                    children: [
                      //Notification//
                      // profileRowButton(
                      //     buttonAction: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   const ScreenNotifications()));
                      //     },
                      //     context: context,
                      //     image: "images/notification.png",
                      //     name: "Notifications"),

                      /// HIDE LANGUAGE

                      // profileRowButton(
                      //     buttonAction: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => const ScreenLanguage()));
                      //     },
                      //     context: context,
                      //     image: "images/address-book.png",
                      //     name: "Language"),
                      profileRowButton(
                          buttonAction: () {
                            launchInBrowser(Uri.parse(telephone));

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const ScreenContactDetails()));
                          },
                          context: context,
                          image: "images/contact.png",
                          name: "Contact Us"),
                      profileRowButton(
                          buttonAction: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SecuritySettings()));
                          },
                          context: context,
                          image: "images/security icon.png",
                          name: "Security"),
                      profileRowButton(
                          buttonAction: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ScreenAbout()));
                          },
                          context: context,
                          image: "images/about-app.png",
                          name: "About App"),
                      const Divider(
                        color: Colors.grey,
                        indent: 10,
                        endIndent: 10,
                      ),
                      height5,
                      if (value.box.read("token") != null)
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return signOutDialogue(context, value);
                                });
                            // signOutDialogue(context, value);
                            // FacebookAuth.instance.logOut();
                            // final GoogleSignIn _googleSignIn = GoogleSignIn();
                            // _googleSignIn.signOut();
                            // value.removetoken();
                            // box.remove("quoteIdLogin");
                            // if (box.read("quoteIdGuest") == null) {
                            //   Provider.of<CartCounterStore>(context,
                            //           listen: false)
                            //       .guestUsers();
                            // }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            "images/output-onlinepngtools (11).png")),
                                    width20,
                                    const TextInput(
                                      text1: "Sign Out",
                                      colorOfText:
                                          Color.fromARGB(255, 147, 144, 144),
                                      size: 16,
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Text(
                                    "V1.14",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }

  buildLoginedWidget(double width) {
    return Column(
      children: [
        Row(
          children: [
            width5,
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenMyProfile()));
              },
              child: SizedBox(
                height: 60,
                width: 60,
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Center(
                    child: Consumer<CartCounterStore>(
                        builder: (context, value, child) {
                      if (!value.loader2 && value.profileDataList != null) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextInput(
                                text1: value.profileDataList!.firstname![0]
                                    .toUpperCase(),
                                colorOfText: Colors.white,
                                size: 20),
                            TextInput(
                              text1: value.profileDataList!.lastname![0]
                                  .toUpperCase(),
                              colorOfText: Colors.white,
                              size: 20,
                            )
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                  ),
                ),
              ),
            ),
            width5,
            Consumer<CartCounterStore>(builder: (context, value, child) {
              if (!value.loader2 && value.profileDataList != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width - 80,
                      child: TextInput(
                        text1:
                            "${value.profileDataList!.firstname!}  ${value.profileDataList!.lastname!} ",
                        size: 25,
                      ),
                    ),
                    TextInput(
                      text1: value.profileDataList!.email!,
                      size: 13,
                    )
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
          ],
        ),
        height20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            myAccountHorizontalButton(
                buttonfunction: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScreenMyProfile()));
                },
                context: context,
                width: width,
                image: "images/profile.png",
                name: "My Profile"),
            myAccountHorizontalButton(
                buttonfunction: () {
                  launchInBrowser(Uri.parse(whatsappUrl));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ScreenMyorders()));
                },
                context: context,
                image: "images/whatsapp.png",
                width: width,
                name: 'Whatsapp'),
            myAccountHorizontalButton(
                buttonfunction: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ScreenMyorders()));
                },
                context: context,
                image: "images/subscribe.png",
                width: width,
                name: 'Subscribe'),
            myAccountHorizontalButton(
                buttonfunction: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScreenFavorite()));
                },
                context: context,
                image: "images/heart.png",
                width: width,
                name: 'Favourites'),
          ],
        ),
        height10,
        profileRowButton(
            buttonAction: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenMyorders()));
            },
            context: context,
            image: "images/order.png",
            name: "My Orders"),
        profileRowButton(
            buttonAction: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenAddressBook(
                            isBasket: false,
                          )));
            },
            context: context,
            image: "images/address-book.png",
            name: "Address Book"),
        // profileRowButton(
        //     buttonAction: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const ScreenPayment()));
        //     },
        //     context: context,
        //     image: "images/payment.png",
        //     name: "Payment"),
      ],
    );
  }

  signOutDialogue(BuildContext context, value) {
    return AlertDialog(
      title: Text('Sign Out'),
      content: Text('Are you sure you want to sign out?'),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text('YES'),
          onPressed: () {
            // FacebookAuth.instance.logOut();
            final GoogleSignIn _googleSignIn = GoogleSignIn();
            _googleSignIn.signOut();
            value.removetoken();
            box.remove("quoteIdLogin");
            if (box.read("quoteIdGuest") == null) {
              Provider.of<CartCounterStore>(context, listen: false)
                  .guestUsers();
            }

            indexChangeNotifier.value = 0;
            ChangeNotifier();

            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }

  buildNotLoginedWidget(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 231, 165, 173),
                      child: TextInput(
                          text1: "H",
                          size: 22,
                          colorOfText: Colors.white,
                          weight: FontWeight.w400),
                    ),
                  ),
                  width20,
                  Column(
                    children: [
                      const TextInput(
                        text1: "Hi Guest",
                        size: 17,
                        weight: FontWeight.bold,
                      ),
                      CustomButton2(
                        width: 80,
                        buttonName: "LOGIN",
                        buttonAction: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ScreenLoginPage()));
                          setState(() {});
                        },
                      )
                    ],
                  )
                ],
              ),
              InkWell(
  onTap: () {
    // Your action when the image is tapped
  },
  child: Padding(
    padding: const EdgeInsets.only(right: 10),
    child: SizedBox(
      height: 28,
      width: 28,
      child: Image.asset("images/Untitled-1.png"),
    ),
  ),
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
),

            ],
          ),
        ),
        profileRowButton(
            buttonAction: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenOrdersWithoutLogin()));
            },
            context: context,
            image: "images/order.png",
            name: "Orders"),
      ],
    );
  }

  profileRowButton({context, image, name, buttonAction}) {
    return InkWell(
      onTap: () {
        buttonAction();
      },
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(height: 25, width: 25, child: Image.asset(image)),
                    width20,
                    TextInput(
                      text1: name,
                      size: 18,
                    )
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell myAccountHorizontalButton(
      {width, image, name, context, buttonfunction}) {
    return InkWell(
      onTap: buttonfunction,
      child: Column(
        children: [
          Container(
            height: width / 6.7,
            width: width / 6.7,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset(image, color: Colors.black),
            ),
          ),
          height10,
          TextInput(text1: name)
        ],
      ),
    );
  }
}
