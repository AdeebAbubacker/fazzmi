import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
|                            |
|---for use android alert--- | 
|                            | 
*/

class AlertAndroidWidget extends StatelessWidget {
  const AlertAndroidWidget({
    super.key,
    this.title,
    this.content,
    this.onCancelAction,
    this.submitAction,
    required this.onCancelchild,
    required this.submitchild,
  });

  final Widget? title;
  final Widget? content;
  final Widget onCancelchild;
  final Widget submitchild;
  final void Function()? onCancelAction;
  final void Function()? submitAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(onPressed: onCancelAction, child: onCancelchild),
            TextButton(onPressed: submitAction, child: submitchild)
          ],
        )
      ],
    );
  }
}

/*
|                        |
|---for use ios alert--- | 
|                        | 
*/
class AlertIOSWidget extends StatelessWidget {
  const AlertIOSWidget({
    super.key,
    this.title,
    this.content,
    this.onCancelAction,
    this.submitAction,
    required this.onCancelchild,
    required this.submitchild,
  });
  final Widget? title;
  final Widget? content;
  final Widget onCancelchild;
  final Widget submitchild;
  final void Function()? onCancelAction;
  final void Function()? submitAction;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: title,
      content: content,
      actions: [
        CupertinoDialogAction(child: onCancelchild, onPressed: onCancelAction),
        CupertinoDialogAction(child: submitchild, onPressed: submitAction)
      ],
    );
  }
}


/* for use ios alert dialog */

      // showCupertinoDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertIOSWidget(
      //         title: const Text("Start a new basket?"),
      //         content: Text(
      //             "Your basket contains items from '_____.'\nDo you want to clear the cart, and shop from ${widget.storename}?"),
      //         onCancelchild: const Text("Cancel"),
      //         submitchild: const Text("Start"),
      //         onCancelAction: () {
      //           Navigator.of(context).pop();
      //         },
      //         submitAction: () {
      //           Navigator.of(context).pop();
      //         },
      //       );
      //     },
      //   );

        
/* for use android alert dialog */

        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertAndroidWidget(
        //         title: const Text("Start a new basket?"),
        //         content: Text(
        //             "Your basket contains items from '_____.'\nDo you want to clear the cart, and shop from ${widget.storename}?"),
        //         onCancelchild: const Text("Cancel"),
        //         submitchild: const Text("Start"),
        //         onCancelAction: () {
        //           Navigator.of(context).pop();
        //         },
        //         submitAction: () {
        //           Navigator.of(context).pop();
        //         },
        //       );
        //     });