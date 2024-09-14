import 'package:flutter/material.dart';

import 'textInput.dart';

class CustomButton extends StatelessWidget {
  final void Function()? customButton;
  final String buttonName;
  final Color? color;
  final double? width;
  const CustomButton({
    Key? key,
    required this.buttonName,
    required this.customButton,
    this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          height: 50,
          width: width,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
              ),
              onPressed: customButton,
              child: TextInput(
                text1: buttonName,
                size: 17,
              ))),
    );
  }
}
