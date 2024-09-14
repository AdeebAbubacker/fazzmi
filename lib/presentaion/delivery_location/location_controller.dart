// import 'dart:convert';

// import 'package:fazzmi/presentaion/delicery_location/get_location.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_webservice/src/places.dart';

// class LocationController extends GetxController {
//   Placemark _pickPlaceMark = Placemark();
//   Placemark get pickPlaceMark => _pickPlaceMark;
//   List<Prediction> _predictionList = [];
//   Future<List<Prediction>> searchLocation(
//       BuildContext context, String text) async {
//     if (text != null && text.isNotEmpty) {
//       http.Response response = await getLocationData(text);
//       var data = jsonDecode(response.body.toString());

//       if (data['status'] == 'ok') {
//         _predictionList = [];
//         data['predictions'].forEach((prediction) =>
//             _predictionList.add(Prediction.fromJson(prediction)));
//       } else {
//         //ApiChecker.checkApi(responsee);
//       }
//     }
//     return _predictionList;
//   }
// }
