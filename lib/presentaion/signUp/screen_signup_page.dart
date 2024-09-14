import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:fazzmi/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/cartInStore.dart';
import '../../widgets/textInput.dart';

class ScreenSignupPage extends StatefulWidget {
  const ScreenSignupPage({Key? key}) : super(key: key);

  @override
  State<ScreenSignupPage> createState() => _ScreenSignupPageState();
}

class _ScreenSignupPageState extends State<ScreenSignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final emailController = TextEditingController();
  bool obserText = true;

  final passwordController = TextEditingController();
  saveSignUpForm() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      var email = emailController.text;
      var password = passwordController.text;
      var firstname = firstNameController.text;
      var lastname = lastNameController.text;
      var response =
          await ApiServices().signUpForm(email, password, firstname, lastname);
      var response2 = await ApiServices().loginForm(email, password);
      if (response == "Success") {
        if (response2["success"] == "success") {
          Provider.of<CartCounterStore>(context, listen: false)
              .saveToken(token: response2["body"]);
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("SignUp Error"),
                content: Text("$response"),
                actions: [
                  TextButton(
                      onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const TextInput(
            text1: "Sign Up",
            colorOfText: Colors.black,
            size: 21.33,
          ),
          actions: [
            SizedBox(
                height: 20,
                width: 20,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset("images/22_LOGIN PAGE-5.png"))),
            width20
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextInput(
                      text1: "Create a ",
                      size: 22,
                    ),
                    TextInput(
                      text1: " FAZZMI",
                      colorOfText: primaryColor,
                      size: 22,
                    ),
                    TextInput(
                      text1: " account",
                      size: 22,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                nameWithTestFormField(
                    context: context,
                    widget: TextFormField(
                      maxLength: 18,
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        counterText: "",
                        hintText: 'Please enter your first name',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    textFieldName: "First name"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                nameWithTestFormField(
                    widget: TextFormField(
                      maxLength: 18,
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        counterText: "",
                        hintText: 'Please enter your last name',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    context: context,
                    textFieldName: "Last name"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                nameWithTestFormField(
                    widget: TextFormField(
                      maxLength: 30,
                      controller: emailController,
                      decoration: const InputDecoration(
                        counterText: "",
                        hintText: 'Please enter your email address',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    context: context,
                    textFieldName: "Email"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                nameWithTestFormField(
                    widget: TextFormField(
                      maxLength: 18,
                      obscureText: obserText,
                      controller: passwordController,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Please enter your password',
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                obserText = !obserText;
                              });
                              FocusScope.of(context).unfocus();
                            },
                            child: Icon(
                              obserText == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6 || value.length > 16) {
                          return 'Password must contain 6-16 digit';
                        }
                        return null;
                      },
                    ),
                    context: context,
                    textFieldName: "Password"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        buttonName: "Sign Up",
                        customButton: () {
                          saveSignUpForm();
                        },
                        width: MediaQuery.of(context).size.width,
                        color: primaryColor,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    const TextInput(
                        text1: "Already have an account? ",
                        colorOfText: Colors.grey),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const TextInput(
                            text1: "Login", colorOfText: primaryColor)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column nameWithTestFormField(
      {context, textFieldName, labelText, controller, suffixicon, widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInput(text1: textFieldName),
        SizedBox(width: MediaQuery.of(context).size.width, child: widget),
      ],
    );
  }
}
