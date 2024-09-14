import 'package:fazzmi/widgets/custom_rounded_container.dart';
import 'package:flutter/material.dart';

class CustomListview extends StatelessWidget {
  CustomListview(
      {required this.listviewIndex,
      super.key,
      this.function,
      required this.image,
      required this.itemCount,
      required this.title});

  int itemCount, listviewIndex;
  void Function()? function;
  String title, image;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 5,
            crossAxisCount: 4,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2),
        itemCount: itemCount,
        itemBuilder: (BuildContext ctx, listviewIndex) {
          return RoundedContainer(
            roundedContainerFunction: function,
            containerTitle: title,
            containerImage: image,
          );
        });
  }
}
