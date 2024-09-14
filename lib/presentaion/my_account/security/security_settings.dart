import 'package:fazzmi/core/constants/commonMethods.dart';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/core/constants/urls.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({super.key});

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(int.parse('F7F7F7', radix: 16)).withOpacity(1.0);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Security Settings",
        icon: Icons.arrow_back_ios,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              color: myColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align text to the left
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text within column
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "  Account Deletion",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "  We are sad to see you go, but hope to see you again.",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            launchInBrowser(Uri.parse(deleteAccountUrl));
                          },
                          child: Text(
                            "Delete Your Account",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
