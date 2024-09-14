import 'package:fazzmi/core/constants/constants.dart';
import 'package:flutter/material.dart';

import 'textInput.dart';

class CustomButton2 extends StatelessWidget {
  final void Function()? buttonAction;
  final String buttonName;
  final double? width;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final double? textSize;
  const CustomButton2({
    Key? key,
    required this.buttonName,
    this.borderColor,
    this.width,
    this.height,
    this.buttonAction,
    this.color,
    this.textSize,
    this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
              color: borderColor == null ? primaryColor : borderColor!,
              width: 2), backgroundColor: color,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: buttonAction,
        child: TextInput(
          text1: buttonName,
          size: textSize,
          colorOfText: textColor,
        ),
      ),
    );
  }
}
