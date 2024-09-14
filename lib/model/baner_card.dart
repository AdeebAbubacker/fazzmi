import 'package:flutter/material.dart';

class BannerCard extends StatelessWidget {
  final String url;
  const BannerCard({
    required this.url,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(fit: BoxFit.fill, image: AssetImage(url)),
      ),
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
    );
  }
}
