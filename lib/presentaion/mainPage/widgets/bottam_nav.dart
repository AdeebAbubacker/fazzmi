import 'package:fazzmi/core/constants/constants.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChangeNotifier,
      builder: (context, int newIndex, _) {
        return BottomNavigationBar(
          selectedFontSize: 12,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          currentIndex: newIndex,
          selectedItemColor: primaryColor,
          elevation: 0,
          onTap: (index) {
            indexChangeNotifier.value = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: ImageIcon(
                    AssetImage("images/Vector Smart Object copy 7.png")),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: ImageIcon(AssetImage("images/categories.png")),
                ),
                label: 'Categories'),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(5.0),
                child: ImageIcon(AssetImage("images/Vector Smart Object2.png")),
              ),
              label: "Deals",
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(5.0),
                  child:
                      ImageIcon(AssetImage("images/Vector Smart Object11.png")),
                ),
                label: 'My Account'),
          ],
        );
      },
    );
  }
}
