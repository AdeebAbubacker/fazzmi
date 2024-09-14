import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String text1;
  final double? size;
  final FontWeight? weight;
  final Color? colorOfText;
  final bool? maxlines;
  final int? maxLines;
  final TextDecoration? decoration;

  final TextAlign? textAlign;

  const TextInput({
    this.textAlign,
    this.maxlines,
    this.colorOfText,
    required this.text1,
    this.size,
    Key? key,
    this.weight,
    this.maxLines,
    this.decoration, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text1,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: weight,
        color: colorOfText,
        fontSize: size,
        fontFamily: "Poppins",
        decoration: decoration,
      ),
      softWrap: maxlines,
      maxLines: maxLines,
    );
  }
}
