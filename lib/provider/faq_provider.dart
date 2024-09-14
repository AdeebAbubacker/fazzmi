import 'dart:convert';

import 'package:fazzmi/model/faqModel/faqModel.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class FaqProvider with ChangeNotifier {
  FaqModel? _faqlList;
  FaqModel? get faqlList => _faqlList;

  bool _faqloader = true;
  bool get faqloader => _faqloader;

  setFaqLoader(bool val) {
    _faqloader = val;
    notifyListeners();
  }

  Future<FaqModel?> getFaqDetails() async {
    try {
      setFaqLoader(true);

      var response =
          await ApiServices().getDataValue("/rest/V1/fazmmi-apis/getFaq");

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        _faqlList = FaqModel.fromJson(jsonMap);
      }
    } catch (e) {
      return _faqlList;
    }
    setFaqLoader(false);

    return _faqlList;
  }
}
