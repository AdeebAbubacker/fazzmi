import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/login/forgotPassword/screenForgotpassword.dart';
import 'package:fazzmi/presentaion/mainPage/screen_main_page.dart';
import 'package:fazzmi/presentaion/signUp/screen_signup_page.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../../widgets/textInput.dart';
import '../../mainPage/widgets/bottam_nav.dart';

class ScreenLoginEmail extends StatefulWidget {
  const ScreenLoginEmail({Key? key}) : super(key: key);
  @override
  State<ScreenLoginEmail> createState() => _ScreenLoginEmailState();
}

class _ScreenLoginEmailState extends State<ScreenLoginEmail> {
  var box = GetStorage();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  bool obserText = true;
  final passwordController = TextEditingController();
  saveLoginForm() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      var email = emailController.text;
      var password = passwordController.text;
      var response = await ApiServices().loginForm(email, password);
      if (response["success"] == "success") {
        Provider.of<CartCounterStore>(context, listen: false)
            .saveToken(token: response["body"]);

        emailController.clear();
        passwordController.clear();

        if (box.read("quoteIdGuest") != null &&
            box.read("customerId") != null) {
          await Provider.of<CartCounterStore>(context, listen: false)
              .mergeguest();
        }
        setState(() {
          isLoading = false;
        });
      //   Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ScreenHome()),
      //     indexChangeNotifier.value = 0;
      //       ChangeNotifier();
      // );
       Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ScreenMainPage()),
                                (Route<dynamic> route) => false);
                            indexChangeNotifier.value = 0;
                            ChangeNotifier();
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("${response["body"]['message']}"),
                title: const Text("Login Error!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              );
            });
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  fncSendOTP() async {
    var response = await ApiServices().sendForgotOTP(emailController.text);
    if (response["success"] == "success") {
      return response['body'];
    } else {
      return false;
    }
  }

  fncReset() {
    Navigator.pop(context);
    fncSendOTP().then((val) async {
      if (val) {
        //when api is working correctly..ie, email fnct ready from backend remove `!`
        buildDialogPop(context);
      }
    });
  }

  buildDialogPop(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width - 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 60,
                      color: primaryColor,
                    ),
                    const TextInput(
                      text1: "Succeeded",
                      size: 20,
                    ),
                    TextInput(
                      text1: emailController.text,
                      colorOfText: primaryColor,
                    ),
                    Column(
                      children: const [
                        TextInput(
                          text1: "You will recieve an email with an OTP",
                          colorOfText: Colors.grey,
                        ),
                        TextInput(
                          text1: "to reset your password",
                          colorOfText: Colors.grey,
                        ),
                      ],
                    ),
                    CustomButton(
                        color: primaryColor,
                        buttonName: "Ok",
                        customButton: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordsreen(
                                  email: emailController.text,
                                ),
                              ));
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Login", icon: Icons.arrow_back_ios),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                const TextInput(
                  text1: "Hello, Welcome back!",
                  size: 20,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                const TextInput(text1: "Email"),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: TextFormField(
                    maxLength: 30,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    controller: emailController,
                    decoration: const InputDecoration(
                      counterText: "",
                      hintText: 'Enter the email',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "Enter Correct Email Address";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                const TextInput(text1: "Password"),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: TextFormField(
                    maxLength: 20,
                    autofillHints: const [AutofillHints.password],
                    controller: passwordController,
                    obscureText: obserText,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Enter the password',
                      suffixIcon: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          setState(() {
                            obserText = !obserText;
                          });
                        },
                        child: Icon(
                          obserText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: SizedBox(
                                height: 300,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const TextInput(
                                          text1: "Forgot your password",
                                          colorOfText: primaryColor,
                                        ),
                                        SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: Image.asset(
                                                "images/22_LOGIN PAGE-5.png",
                                              ),
                                            ))
                                      ],
                                    ),
                                    const TextInput(
                                      maxLines: 2,
                                      size: 16,
                                      text1:
                                          "Please enter your email to reset password",
                                      colorOfText: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Colors.grey,
                                          focusColor: Colors.grey,
                                          hintText: "Example@info.com",
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter the email';
                                          }
                                          if (!RegExp(
                                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                              .hasMatch(value)) {
                                            return "Enter Correct Email Address";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                      ),
                                    ),
                                   CustomButton(
  color: primaryColor,
  width: MediaQuery.of(context).size.width,
  buttonName: "Reset",
  customButton: () {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      // Email text is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Empty Email'),
            content: Text('Please enter your email.'),
            actions: <Widget>[
             TextButton(
  child: Text('OK'),
  onPressed: () {
    Navigator.of(context).pop();
  },
)
            ],
          );
        },
      );
      return; // Exit the function
    }

    bool isValidEmail = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)*\.[a-zA-Z\d-]{2,}$').hasMatch(email);
    if (!isValidEmail) {
      // Invalid email format
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Email'),
            content: Text('Please enter a valid email address.'),
            actions: <Widget>[
              TextButton(
  child: Text('OK'),
  onPressed: () {
    Navigator.of(context).pop();
  },
)
            ],
          );
        },
      );
      return; // Exit the function
    }

    // Email is not empty and valid, continue with the code
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordsreen(
              email: email,
            ),
          ),
        );
        fncSendOTP();
      },
    );
  },
),

                                  ],
                                ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          );
                        });
                  },
                  child: const TextInput(
                    text1: "Forgot your password ?",
                    colorOfText: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        color: primaryColor,
                        width: MediaQuery.of(context).size.width,
                        buttonName: "Login",
                        customButton: () async {
                          await saveLoginForm();
                        }),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextInput(
                        text1: "Don't have an account ?",
                        colorOfText: Colors.grey),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ScreenSignupPage()));
                        },
                        child: const TextInput(
                            text1: " Sign Up ", colorOfText: primaryColor)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
