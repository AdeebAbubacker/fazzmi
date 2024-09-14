import 'dart:async';

import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../services/api_services.dart';
import '../../../../widgets/custom_button.dart';

class ScreenchangePassword extends StatefulWidget {
  const ScreenchangePassword({Key? key}) : super(key: key);

  @override
  State<ScreenchangePassword> createState() => _ScreenchangePasswordState();
}

class _ScreenchangePasswordState extends State<ScreenchangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final currerntPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  final confirmNewPasswrodController = TextEditingController();
  bool _obserText = false;

  saveSignUpForm() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      var currentPasswordTXT = currerntPasswordController.text;
      var newPasswordTXT = newPasswordController.text;
      var confirmPasswordTXT = confirmNewPasswrodController.text;
      var response = await ApiServices().changePassword(
          currentPassword: currentPasswordTXT, newPaswword: newPasswordTXT);

      if (response == "Success") {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Success"),
                content: const Text('Password updated!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Timer(Duration(seconds: 1), () {
                          Navigator.pop(
                              context); // Navigates back to previous screen
                        });
                      },
                      child: const Text("OK"))
                ],
              );
            });
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error"),
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
      appBar: const CustomAppBar(
        title: "Change Password",
        icon: Icons.arrow_back_ios,
      ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                nameWithTestFormField(
                    context: context,
                    widget: TextFormField(
                      maxLength: 15,
                      obscureText: _obserText,
                      controller: currerntPasswordController,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Please enter current password',
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _obserText = !_obserText;
                              });
                              FocusScope.of(context).unfocus();
                            },
                            child: Icon(
                              _obserText == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Current password required';
                        }
                        return null;
                      },
                    ),
                    textFieldName: "Current Password"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                nameWithTestFormField(
                    widget: TextFormField(
                      maxLength: 15,
                      obscureText: _obserText,
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: 'Please enter new password',
                        hintStyle: const TextStyle(color: Colors.grey),
                        // suffixIcon: InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       _obserText = !_obserText;
                        //     });
                        //     FocusScope.of(context).unfocus();
                        //   },
                        //   child: Icon(
                        //     _obserText == true
                        //         ? Icons.visibility_off
                        //         : Icons.visibility,
                        //     color: Colors.grey,
                        //   ),
                        // )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New password required';
                        }
                        if (value.length < 6 || value.length > 16) {
                          return 'Password must contain 6-16 digit';
                        }
                        return null;
                      },
                    ),
                    context: context,
                    textFieldName: "New Password"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                nameWithTestFormField(
                    widget: TextFormField(
                      maxLength: 15,
                      obscureText: _obserText,
                      controller: confirmNewPasswrodController,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Please enter confirm new password',
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _obserText = !_obserText;
                              });
                              FocusScope.of(context).unfocus();
                            },
                            child: Icon(
                              _obserText == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm new paswword required';
                        }
                        if (newPasswordController.text != value) {
                          return 'confirm password dismatch';
                        }
                        return null;
                      },
                    ),
                    context: context,
                    textFieldName: "Confirm New Password"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        buttonName: "Submit",
                        customButton: () {
                          saveSignUpForm();
                        },
                        width: MediaQuery.of(context).size.width,
                        color: primaryColor,
                      ),
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
