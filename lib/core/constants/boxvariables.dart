import 'package:get_storage/get_storage.dart';

var box = GetStorage();
var selectedpincode = box.read("selectedPinCode");
var boxcartQuoteId = box.read("cartQuoteId");
