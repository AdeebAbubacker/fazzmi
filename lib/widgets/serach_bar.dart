import 'package:fazzmi/core/constants/constants.dart';

import 'package:flutter/material.dart';
import '../presentaion/Search/ScreenSerachDummy.dart';
import 'textInput.dart';

class CustomSearchBar extends StatelessWidget {
  final text;
  const CustomSearchBar({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScreenSearchh()));
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(children: [
            width10,
            SizedBox(
                height: 20,
                width: 20,
                child: ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.dstIn),
                  child: Image.asset("images/serachicon.png"),
                )),
            width10,
            Expanded(
                child: Align(
              alignment: Alignment.centerLeft,
              child: TextInput(
                text1: text,
                colorOfText: Colors.grey,
              ),
            ))
          ]),
        ),
      ),
    );
  }
}
