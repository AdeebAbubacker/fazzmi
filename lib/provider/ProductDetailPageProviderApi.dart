import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fazzmi/model/productDetailModel/productDetailPageModel.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class ProductDetailPageProviderApi with ChangeNotifier {
  ProductDetailPageModel? _productDetailList;
  ProductDetailPageModel? get productDetailList => _productDetailList;
  List<Variation?>? _varionList;
  String? _productName;
  String? get productName => _productName;
  String? _sku;
  String? get sku => _sku;
  String? _productType;
  String? get productType => _productType;
  String? _description;
  String? get description => _description;
  String? _shortDescription;
  String? get shortDescription => _shortDescription;
  String? _selections;
  String? get selections => _selections;
  var _cutOfTime = 0;
  get cutOfTime => _cutOfTime;
  List<Variation?>? get varionList => _varionList;

  ///// Example for countdown

  Timer? countdownTimer;
  Duration myDuration = const Duration(days: 5);
  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());

    notifyListeners();
  }

  void setSelection({select}) {
    _selections = select;
    notifyListeners();
  }

  void setCountDown() {
    const reduceSecondsBy = 1;

    final seconds = myDuration.inSeconds - reduceSecondsBy;

    notifyListeners();
    if (seconds < 0) {
      countdownTimer!.cancel();
      notifyListeners();
    } else {
      myDuration = Duration(seconds: seconds);
      notifyListeners();
    }
  }

  bool _loader = true;
  bool get loader => _loader;
  bool _loader2 = true;
  bool get loader2 => _loader2;
  setLoader2(bool val) {
    _loader2 = val;
    notifyListeners();
  }

  setLoader(bool val) {
    _loader = val;
    notifyListeners();
  }

  /// VARTIONS VALUE

  int _valueColor = 0;
  int get valueColor => _valueColor;

  void changeColor({value}) {
    _valueColor = value;
    notifyListeners();
  }

  int _valueSize = 0;
  int get valueSize => _valueSize;

  void changeSize({value}) {
    _valueSize = value;
    notifyListeners();
  }

  /// OPTION CONTENT
  int _optionColor = 0;
  int get optionColor => _optionColor;

  void changeOptionColor({value}) {
    _optionColor = value;
    notifyListeners();
  }

  int _optionSize = 0;
  int get optionSize => _optionSize;

  void changeOptionSize({value}) {
    _optionSize = value;
    notifyListeners();
  }

  /// change the mode of Ui of product detail page image

  Future<void> changeMode() async {
    _productDetailList = [] as ProductDetailPageModel?;

    notifyListeners();
  }

  Future<ProductDetailPageModel?> getProductDetails(
      {color = 0, size = 0, sku, selection = "0"}) async {
    var url = '/rest/V1/fazmmi-apis/getchildproduct?sku=$sku';
    // log(sku);
    print("uuuu:$sku");
    setSelection(select: selection);

    try {
      setLoader(true);

      var eUrl = null;
      if (size != 0) {
        eUrl = '&size=$size';
      }
      if (color != 0) {
        eUrl = '&color=$color';
      }
      if (size != 0 && color != 0) {
        eUrl = '&color=$color&size=$size&selection=$selection';
      }

      var response =
          await ApiServices().getDataValue((eUrl == null) ? url : url + eUrl);

      if (response.statusCode == 200) {
        var jsonString = response.body;

        var jsonMap = jsonDecode(jsonString);

        _productDetailList = ProductDetailPageModel.fromJson(jsonMap);

        if (size == 0 && color == 0) {
          var productNameOf = jsonMap['data']['product_info']['name'];
          var descriptionOf = jsonMap['data']['product_info']['description'];
          var productType = jsonMap['data']['product_info']['type_id'];
          var sku = jsonMap['data']['product_info']['sku'];
          var shortDescriptionOf =
              jsonMap['data']['product_info']['short_description'];
          _productName = productNameOf;
          _description = descriptionOf;
          _sku = sku;
          _productType = productType;
          _shortDescription = shortDescriptionOf;
          var list = jsonMap['data']['product_info']['variations'] as List;
          _varionList = list.map((e) => Variation.fromJson(e)).toList();

          List<String> colorP = checkKey("Color");
          List<String> sizeP = checkKey("size");
          var optionIdColor = checkOption("Color");
          var optionIdSize = checkOption("size");

          if (colorP.isNotEmpty) {
            changeColor(value: int.parse(colorP.first));
            changeOptionColor(value: optionIdColor.first);
          }
          if (sizeP.isNotEmpty) {
            changeSize(value: int.parse(sizeP.first));
            changeOptionSize(value: optionIdSize.first);
          }
        }
      }
    } catch (e) {
      return _productDetailList;
    }
    setLoader(false);

    return _productDetailList;
  }

  checkKey(key) {
    var res = _varionList!.map((e) {
      if (e!.title == key) {
        var idx = _varionList!.indexOf(e);

        return e.content!.first.id;
      }
    }).toList();

    res.removeWhere((e) => e == null);
    return List<String>.from(res);
  }

  checkOption(key) {
    var res = _varionList!.map((e) {
      if (e!.title == key) {
        return e.attributeId;
      }
    }).toList();
    res.removeWhere((e) => e == null);
    return res;
  }
}
