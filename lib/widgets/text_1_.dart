import 'package:flutter/material.dart';

class Text1 extends StatelessWidget {
  final String textname;
  const Text1({
    Key? key,
    required this.textname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textname,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: "Poppins",
          fontSize: 20),
    );
  }
}
