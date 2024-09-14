import 'package:fazzmi/core/constants/constants.dart';
import 'package:flutter/material.dart';
import '../../widgets/textInput.dart';

class WithoutIconWidget extends StatelessWidget {
  final String text2;
  final String time;
  final String? paraBold;
  final String? paragraph;

  const WithoutIconWidget({
    required this.time,
    this.paragraph,
    this.paraBold,
    required this.text2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInput(
                        maxLines: 2,
                        text1: text2,
                        colorOfText: Colors.red,
                        size: 18)),
                TextInput(
                    textAlign: TextAlign.left,
                    text1: time,
                    colorOfText: Colors.grey,
                    size: 10),
                height10,
              ],
            ),

            // const Icon(Icons.more_horiz)
          ],
        ),
        // Row(
        //
        //
        //   children: [
        //     TextInput( text1:parabold,
        //
        //     ),
        //     Spacer(),
        //     TextInput(
        //       text1:paragraph ,
        //     ),
        //
        //
        //   ],
        //
        // ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: paraBold,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: "Poppins")),
              TextSpan(
                  text: paragraph,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: "Poppins")),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
