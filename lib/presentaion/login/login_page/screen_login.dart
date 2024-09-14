import 'dart:async';
import 'dart:convert';

import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/login/login_email/screen_login_email.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../widgets/textInput.dart';

class ScreenLoginPage extends StatefulWidget {
  const ScreenLoginPage({Key? key}) : super(key: key);
  @override
  State<ScreenLoginPage> createState() => _ScreenLoginPageState();
}

class _ScreenLoginPageState extends State<ScreenLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  // void _loginWithFacebook() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final facebookLoginResult = await FacebookAuth.instance.login();
  //     final user = await FacebookAuth.instance.getUserData();

  //     final FacebookAuthCredential = FacebookAuthProvider.credential(
  //         facebookLoginResult.accessToken!.token);
  //     await FirebaseAuth.instance.signInWithCredential(FacebookAuthCredential);

  //     await FirebaseFirestore.instance.collection('user').add({
  //       'email': user['email'],
  //       'imageurl': user['picture']['data']['url'],
  //       'name': user['name'],
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     var title = '';
  //     switch (e.code) {
  //       case 'account alredy exist with differentcredential':
  //         title = 'this account exists with a different provider';
  //         break;
  //     }
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
                height: 20,
                width: 20,
                child: Image.asset("images/22_LOGIN PAGE-5.png")),
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: InkWell(
        //       onTap: () {
        //         Navigator.pop(context);
        //       },
        //       child: const TextInput(
        //         text1: "Guest",
        //         size: 20,
        //         colorOfText: primaryColor,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Center(
        child: ListView(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              child: Image.asset("images/Fazzmi_logo.png")),
          const Align(
            alignment: Alignment.center,
            child: TextInput(
              text1: "Your Everyday, Right Away",
              colorOfText: Colors.grey,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                    width: (MediaQuery.of(context).size.width / 3) - 20,
                    child: Image.asset("images/22_LOGIN PAGE-8.png")),
                SizedBox(
                    width: (MediaQuery.of(context).size.width / 3) - 20,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Image.asset("images/22_LOGIN PAGE-9.png")),
                SizedBox(
                    width: (MediaQuery.of(context).size.width / 3) - 20,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Image.asset("images/22_LOGIN PAGE-10.png")),
              ],
            ),
          ),
          const Center(
            child: TextInput(
              text1: "Log in or create an account",
              size: 20,
              weight: FontWeight.bold,
            ),
          ),
          height10,
          const Center(
            child: TextInput(
              text1: "Receive rewards and save your details for a faster",
              size: 12,
              colorOfText: Colors.grey,
            ),
          ),
          const Center(
            child: TextInput(
              text1: "checkout experience.",
              size: 12,
              colorOfText: Colors.grey,
            ),
          ),
          height20,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                roundedBorderOnlyButton(
                    buttonAction: () async {
                      User? user = await signInWithGoogle();

                      if (user != null) {
                        showLoaderDialog(context);

                        ///
                        var response = await ApiServices()
                            .loginWithFacebookOrGoogle(
                                user.displayName,
                                user.email,
                                user.uid,
                                user.phoneNumber ?? "9946673154",
                                "google");
                        if (response["success"] == "success") {
                          Provider.of<CartCounterStore>(context, listen: false)
                              .saveToken(
                                  token: response["body"]["data"]["quoteId"]);

                          if (box.read("quoteIdGuest") != null &&
                              box.read("customerId") != null) {
                            await Provider.of<CartCounterStore>(context,
                                    listen: false)
                                .mergeguest();
                          }

                          setState(() {
                            isLoading = false;
                          });
                          Timer(const Duration(seconds: 3), () {
                            Navigator.pop(context, "refresh");
                            Navigator.pop(context, "refresh");
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text("${response["body"]}"),
                                  title: const Text("Login Error!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Timer(const Duration(seconds: 3), () {
                                            Navigator.pop(context, "refresh");
                                          });
                                        },
                                        child: const Text("OK"))
                                  ],
                                );
                              });
                          setState(() {
                            isLoading = false;
                          });
                        }

                        ///
                      }
                      // use for signOut
                      /* final GoogleSignIn _googleSignIn = GoogleSignIn();
                         _googleSignIn.signOut();
                       */
                    },
                    image: Image.asset("images/22_LOGIN PAGE-16.png"),
                    name1: "Continue with Google"),
                // roundedBorderOnlyButton(
                //     buttonAction: () {
                //       _loginWithFacebook();
                //     },
                //   LoginResult? facebookResult =  await _loginWithFacebook() as LoginResult?;
                //   if (facebookResult != null &&
                //       facebookResult.accessToken != null) {
                //     showLoaderDialog(context);
                //     var result = await facebookLogin(
                //         facebookResult.accessToken!.token);

                //     if (result["email"] == null) {
                //       HelperDialogue().dialugue(
                //         title: "Oops!!!",
                //         content: "Pls Login with Google or Gmail",
                //         context: context,
                //       );
                //     } else {
                //       var response = await ApiServices()
                //           .loginWithFacebookOrGoogle(
                //               result["name"],
                //               result["email"],
                //               result["id"],
                //               result["phonenumber"] ?? "9946673154",
                //               "facebook");
                //       if (response["success"] == "success") {
                //         Provider.of<CartCounterStore>(context,
                //                 listen: false)
                //             .saveToken(
                //                 token: response["body"]["data"]["quoteId"]);

                //         if (box.read("quoteIdGuest") != null &&
                //             box.read("customerId") != null) {
                //           await Provider.of<CartCounterStore>(context,
                //                   listen: false)
                //               .mergeguest();
                //         }

                //         setState(() {
                //           isLoading = false;
                //         });
                //         Navigator.pop(context);
                //         Navigator.pop(context);
                //       } else {
                //         showDialog(
                //             context: context,
                //             builder: (BuildContext context) {
                //               return AlertDialog(
                //                 content: Text("${response["body"]}"),
                //                 title: const Text("Login Error!"),
                //                 actions: [
                //                   TextButton(
                //                       onPressed: () {
                //                         setState(() {
                //                           isLoading = false;
                //                         });
                //                         Navigator.pop(context);
                //                       },
                //                       child: const Text("OK"))
                //                 ],
                //               );
                //             });
                //         setState(() {
                //           isLoading = false;
                //         });
                //       }
                //     }
                //   }
                //   // for signOut
                //   // await FacebookAuth.instance.logOut();
                // },
                // image: Image.asset("images/22_LOGIN PAGE-19.png"),
                // name1: "Continue with Facebook"),
                roundedBorderOnlyButton(
                    buttonAction: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScreenLoginEmail()));
                    },
                    image: Image.asset("images/output-onlinepngtools.png"),
                    name1: "Continue with Email")
              ],
            ),
          ),
          height20
        ]),
      ),
    );
  }

  roundedBorderOnlyButton({image, name1, buttonAction}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
              primary: Colors.white,
              elevation: 0,
              side: const BorderSide(color: Colors.grey)),
          onPressed: buttonAction,
          child: Row(
            children: [
              SizedBox(height: 30, width: 30, child: image),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextInput(
                  text1: name1,
                  size: 19,
                  colorOfText: Colors.grey,
                ),
              )
            ],
          )),
    );
  }

//google auth starts here
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn().catchError((onError) => print(onError));
    if (googleSignInAccount == null) return null;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    /*
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    */
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential authResult = await _auth.signInWithCredential(credential);
    print("authhhhhh:::::::::::;;;;;;;${authResult.user}");
    return authResult.user;
  }
//end
  // Future<User?> _loginWithFacebook() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final facebookLoginResult = await FacebookAuth.instance.login();
  //     final user = await FacebookAuth.instance.getUserData();

  //     final FacebookAuthCredential = FacebookAuthProvider.credential(
  //         facebookLoginResult.accessToken!.token);
  //     await FirebaseAuth.instance.signInWithCredential(FacebookAuthCredential);

  //     await FirebaseFirestore.instance.collection('user').add({
  //       'email': user['email'],
  //       'imageurl': user['picture']['data']['url'],
  //       'name': user['name'],
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     var title = '';
  //     switch (e.code) {
  //       case 'account alredy exist with differentcredential':
  //         title = 'this account exists with a different provider';
  //         break;
  //     }
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  //   return null;
  // }
  // Future<LoginResult> signInWithFacebook() async {
  //   final LoginResult result = await FacebookAuth.instance.login(
  //     permissions: [
  //       'public_profile',
  //       'email',
  //       'pages_show_list',
  //       'pages_messaging',
  //       'pages_manage_metadata'
  //     ],
  //   );

  //   final OAuthCredential credential =
  //       FacebookAuthProvider.credential(result.accessToken!.token);
  //   await _auth.signInWithCredential(credential);

  //   return result;
  // }

  Future<dynamic> facebookLogin(String token) async {
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
    final profile = json.decode(graphResponse.body);
    String name = profile['name'];
    String email = profile['email'];
    return profile;
  }

  Dialog showLoaderDialog(BuildContext context) {
    Dialog loader = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          child: const CircularProgressIndicator(color: Colors.red),
        ),
      ),
    );

    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return loader;
      },
    );
    return loader;
  }
}
