import 'dart:async';

import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/custom_button.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/api_services.dart';

class ScreenEdit extends StatefulWidget {
  ScreenEdit({Key? key}) : super(key: key);

  @override
  State<ScreenEdit> createState() => _ScreenEditState();
}

class _ScreenEditState extends State<ScreenEdit> {
  var firstName;
  var lastName;
  var email;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CartCounterStore>(context, listen: false)
          .getProfileData(token: box.read("token"));
      firstName = Provider.of<CartCounterStore>(context, listen: false)
          .profileDataList!
          .firstname!;
      lastName = Provider.of<CartCounterStore>(context, listen: false)
          .profileDataList!
          .lastname!;
      email = Provider.of<CartCounterStore>(context, listen: false)
          .profileDataList!
          .email!;
      firstNameController.text = firstName;
      lastNameController.text = lastName;
    });
  }

  bool isLoading = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final communicationController = TextEditingController(text: "English");
  bool obserText = true;

  saveSignUpForm() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      var firstName = firstNameController.text;
      var lastName = lastNameController.text;

      var response = await ApiServices().updateProfileData(
        email: email,
        firstname: firstName,
        lastname: lastName,
      );
      await Provider.of<CartCounterStore>(context, listen: false)
          .getProfileData(token: box.read("token"));

      if (response == "Success") {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Success"),
                content: const Text('Profile Data updated!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Timer(const Duration(seconds: 1), () {
                          Navigator.pop(context);
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
        // ignore: use_build_context_synchronously
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset("images/Fazzmi_logo.png"),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const TextInput(
                  text1: "Cancel",
                  size: 18,
                  colorOfText: Colors.black,
                ),
              ),
            )
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
                        hintText: 'Please enter the first name',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the first name';
                        }
                        return null;
                      },
                    ),
                    textFieldName: "First Name"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                nameWithTestFormField(
                    context: context,
                    widget: TextFormField(
                      maxLength: 18,
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        counterText: "",
                        hintText: 'Please enter the last name',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the last name';
                        }
                        return null;
                      },
                    ),
                    textFieldName: "Last Name"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                // nameWithTestFormField(
                //     context: context,
                //     widget: TextFormField(
                //       controller: communicationController,
                //       decoration: const InputDecoration(
                //         suffixIcon: Icon(
                //           Icons.arrow_forward_ios,
                //           size: 17,
                //         ),
                //         hintText: 'Please enter recieve communication',
                //         hintStyle: TextStyle(color: Colors.grey),
                //       ),
                //       validator: (value) {
                //         if (value == null || value.isEmpty) {
                //           return 'Please enter recieve communication';
                //         }
                //         return null;
                //       },
                //     ),
                //     textFieldName: "Recieve communication in"),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 40,
                // ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        buttonName: "Save",
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
