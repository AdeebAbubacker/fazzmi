import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/custom_button.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';

import '../login_email/screen_login_email.dart';

class ForgotPasswordsreen extends StatefulWidget {
  const ForgotPasswordsreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<ForgotPasswordsreen> createState() => _ForgotPasswordsreenState();
}

class _ForgotPasswordsreenState extends State<ForgotPasswordsreen> {
  var box = GetStorage();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final otpController = TextEditingController();
  bool obserText = true;
  bool obserText1 = true;
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();

  // changePasswordFnc() async {
  //   var response = await ApiServices().forgotPasswordForm(
  //       widget.email, conPasswordController.text, otpController.text);
  //   if (response["success"] == "success") {
  //     // show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Password reset successfully'),
  //       ),
  //     );
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => ScreenLoginEmail()),
  //     );
  //   }
    
  //    else {
  //     // show an error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to reset password'),
  //       ),
  //     );
  //   }
  //   return false;
  // }

  changePasswordFnc() async {
  try {
    var response = await ApiServices().forgotPasswordForm(
        widget.email, conPasswordController.text, otpController.text);
    if (response["success"] == "success") {
      // show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset successfully'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ScreenLoginEmail()),
      );
      
    } 
    else {
      // show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset password'),
        ),
      );
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SnackBar(
          content: Text('Failed to reset password'),
        );
      },
    );
  }
}

String removeSpaces(String text) {
  return text.replaceAll(' ', '');
}
  TextStyle labelStyle = const TextStyle(
    color: Colors.black,
    height: 0.1,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
          title: "Forgot Password", icon: Icons.arrow_back_ios),
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
                  text1: "Reset your password!",
                  size: 20,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: const TextInput(text1: "OTP"),
                      labelStyle: labelStyle,
                      hintText: 'Enter OTP',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: otpController,
                    validator: (val) {
                      if (val == '') {
                        return 'OTP required!';
                      }
                      /////otp condition given
          //             if (val != '1234') {
          //   return 'Invalid OTP!';
          // }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: TextFormField(
                    obscureText: obserText,
                    decoration: InputDecoration(
                      label: const TextInput(text1: "Password"),
                      labelStyle: labelStyle,
                      hintText: 'Enter password',
                      suffixIcon: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            obserText = !obserText;
                          });
                        },
                        child: Icon(obserText == true
                            ? Icons.visibility
                            : Icons.visibility_off,color: Colors.grey,),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: passwordController,
                    validator: (val) {
                      if (val == '') {
                        return 'Password required!';
                      }
                      if (passwordController.length < 8) {
                        return "Password should be at least 8 characters long.";
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: TextFormField(
                    obscureText: obserText1,
                    decoration: InputDecoration(
                      label: const TextInput(text1: "Confirm Password"),
                      labelStyle: labelStyle,
                      hintText: 'Re-enter password',
                      suffixIcon: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            obserText1 = !obserText1;
                          });
                        },
                        child: Icon(obserText1 == true
                            ? Icons.visibility
                            : Icons.visibility_off,color: Colors.grey,),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: conPasswordController,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Password do not match!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 8.0),
                CustomButton(
  color: primaryColor,
  width: MediaQuery.of(context).size.width,
  buttonName: "Reset Password",
  customButton: () async {
    if (_formKey.currentState!.validate()) {
      String password = removeSpaces(passwordController.text);
      String confirmPassword = removeSpaces(conPasswordController.text);
      
      if (password != confirmPassword) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Password Mismatch'),
              content: Text('Password and confirm password must match.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return; 
      }

      if (password.length < 8 || !hasSpecialCharacter(password)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Password'),
              content: Text('Password must be at least 8 characters long and contain at least one special character and number.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return; 
      }

      await changePasswordFnc();
    }
  },
),

                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool hasSpecialCharacter(String password) {
  String specialCharacters = "!@#%^&*(),.?\":{}|<>";
  return password.split('').any((char) => specialCharacters.contains(char));
}