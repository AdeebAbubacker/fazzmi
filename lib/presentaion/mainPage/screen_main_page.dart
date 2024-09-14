import 'package:fazzmi/presentaion/categories/screen_categories.dart';
import 'package:fazzmi/presentaion/deals/screen_deals.dart';
import 'package:fazzmi/presentaion/home/screen_home.dart';
import 'package:fazzmi/presentaion/my_account/screen_my_account.dart';
import 'package:fazzmi/presentaion/mainPage/widgets/bottam_nav.dart';
import 'package:flutter/material.dart';

class ScreenMainPage extends StatelessWidget {
  ScreenMainPage({Key? key}) : super(key: key);

  final _pages = [
    const ScreenHome(),
    const ScreenCategories(),
    const ScreenDeals(),
    ScreenMyAccount()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        builder: (context, int index, _) {
          return _pages[index];
        },
        valueListenable: indexChangeNotifier,
      ),
      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}
