import 'package:fazzmi/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  // show  error Dialog
  static void showErrorDialog(
      {String title = 'Error', String description = "Something went wrong"}) {
    Get.dialog(Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Get.textTheme.headline4,
            ),
            Text(
              description,
              style: Get.textTheme.headline6,
            ),
            ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: const Text("Okey")),
          ],
        ),
      ),
    ));
  }

  // shoe toast
  //show snackbar
  // show loading
  static void showLoading([String? message]) {
    Get.dialog(Dialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircularProgressIndicator(),
        height10,
        Text(message ?? "Loading...")
      ]),
    ));
  }

  //
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}
