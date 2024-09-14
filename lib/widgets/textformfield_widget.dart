import 'package:flutter/material.dart';

class Inputfield extends StatelessWidget {
  const Inputfield({
    Key? key,
    required this.height,
    required this.controller,
    required this.title,
    required this.hint,
  }) : super(key: key);
  final double height;
  final TextEditingController controller;
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(width: 2, color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
