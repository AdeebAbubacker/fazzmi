import 'package:flutter/material.dart';

class Text2 extends StatelessWidget {
  final String textName;
  const Text2({
    Key? key,
    required this.textName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textName,
      style: const TextStyle(
          color: Colors.black, fontFamily: "Poppins", fontSize: 13),
    );
  }
}
