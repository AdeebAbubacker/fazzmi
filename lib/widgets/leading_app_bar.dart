import 'package:flutter/material.dart';

class CustomAppBarLeading extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget widget;
  final void Function()? ontap;
  const CustomAppBarLeading({
    required this.widget,
    Key? key,
    this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: -10,
        leading: InkWell(
          onTap: ontap,
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
        title: widget);
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
