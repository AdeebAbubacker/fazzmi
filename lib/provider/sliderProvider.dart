import 'package:flutter/cupertino.dart';

class SliderProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  changeCurrentIndex({index, imageLength}) {
    _currentIndex = index % imageLength;
    notifyListeners();
  }
}
