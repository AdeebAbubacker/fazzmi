import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';

class TittleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TittleAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: TextInput(
          text1: title,
          colorOfText: Colors.black,
          size: 20,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
