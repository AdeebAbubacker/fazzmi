import 'package:flutter/material.dart';

class HelperDialogue {
  dialugue(
      {required BuildContext context,
      void Function()? onPressed,
      String? title,
      content}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title!),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: onPressed ?? () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          );
        });
  }
}
