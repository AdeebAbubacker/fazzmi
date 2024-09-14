import 'package:fazzmi/sController.dart/test_controller.dart';

import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  TestPage({super.key});
  final controller = TestController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Page"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () async {
                  controller.getData();
                },
                child: const Text("Get Data")),
            ElevatedButton(
                onPressed: () async {
                  controller.postData();
                },
                child: const Text("Post Data")),
          ],
        ),
      ),
    );
  }
}
