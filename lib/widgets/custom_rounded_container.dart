import 'package:fazzmi/core/constants/commonMethods.dart';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  RoundedContainer(
      {super.key,
      this.listviewIndex,
      this.roundedContainerFunction,
      this.containerImage,
      this.containerTitle});
  void Function()? roundedContainerFunction;
  String? containerTitle, containerImage;
  int? listviewIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: roundedContainerFunction,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 9),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(60),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                containerImage!,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset("images/Fazzmi_logo.png"),
              ),
            ),
          ),
        ),
        height10,
        SizedBox(
          width: 70,
          child: TextInput(
              textAlign: TextAlign.center,
              maxLines: 2,
              size: 11,
              text1: capitalizeAllWord(containerTitle!)),
        )
      ],
    );
  }
}
