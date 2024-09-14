import 'package:fazzmi/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? secondTitle;
  final IconData? icon;
  final List<Widget>? action;
  final void Function()? appbarleadingFunction;

  const CustomAppBar({
    this.action,
    this.icon,
    super.key,
    required this.title,
    this.appbarleadingFunction,
    this.secondTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        leading: IconButton(
            onPressed: () {
              appbarleadingFunction == null
                  ? Navigator.pop(context)
                  : appbarleadingFunction!();
            },
            icon: Icon(
              icon,
              color: Colors.grey,
              size: 20,
            )),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            secondTitle == null ? height20 : height5,
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins'),
            ),
            Text(
              secondTitle == null ? "" : secondTitle!,
              style: const TextStyle(
                  color: Colors.black, fontSize: 13, fontFamily: 'Poppins'),
            ),
          ],
        ),
        centerTitle: true,
        actions: action,
        elevation: 0,
      ),
    );
  }
}
