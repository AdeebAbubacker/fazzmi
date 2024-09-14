// import 'dart:async';
// import 'dart:math';
// import 'dart:developer';
// import 'package:fazzmi/core/constans/constants.dart';

// import 'package:fazzmi/presentaion/screen_main_page/screen_main_page.dart';
// import 'package:fazzmi/widgets/customButton2.dart';
// import 'package:fazzmi/widgets/textInput.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
// import 'package:google_maps_webservice/places.dart';
// // // 9.9276409,76.3546861

// const kGoogleApiKey = "AIzaSyB3oZQWckR628FsRz3e15qcVbkLmWDT3VE";

// class ScreenDeliveryLocation extends StatefulWidget {
//   const ScreenDeliveryLocation({Key? key}) : super(key: key);

//   @override
//   State<ScreenDeliveryLocation> createState() => _ScreenDeliveryLocationState();
// }

// class _ScreenDeliveryLocationState extends State<ScreenDeliveryLocation> {
//   final homeScaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController textFormcontroller = TextEditingController();

//   final Completer<GoogleMapController> _controller = Completer();

//   PickResult? selectedPlace;

//   final kInitialPosition = const LatLng(9.9244591, 76.3481106);

//   // String googleApikey = "AIzaSyB3oZQWckR628FsRz3e15qcVbkLmWDT3VE";
//   GoogleMapController? mapController;
//   CameraPosition? cameraPosition;
//   String location = "Location Name:";
//   LatLng? _initialPosition;
//   // LocationPermission? permission;

//   fncConvertToAddress(latitude, longitude) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     _initialPosition = LatLng(latitude, longitude);

//     setState(() {
//       location = placemarks.first.street.toString() +
//           ", " +
//           placemarks.first.administrativeArea.toString() +
//           "\nPin: " +
//           placemarks.first.postalCode.toString();
//       textFormcontroller.text = placemarks.first.street.toString() +
//           ", " +
//           placemarks.first.administrativeArea.toString();
//     });
//   }

//   fctGoSearchAddress() async {
//     PlacesDetailsResponse? detail = await Navigator.push(context,
//         MaterialPageRoute(builder: (context) => CustomSearchScaffold()));
//     if (detail != null) {
//       if (detail.status == "OK") {
//         final selectedLocation = detail.result.geometry;
//         _initialPosition = LatLng(
//             selectedLocation!.location.lat, selectedLocation.location.lng);
//         final GoogleMapController controller = await _controller.future;
//         controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           target: _initialPosition!,
//           zoom: 17.4746,
//         )));

//         fncConvertToAddress(
//             selectedLocation.location.lat, selectedLocation.location.lng);
//       }
//     }
//   }

//   void fncGetUserLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     fncConvertToAddress(position.latitude, position.longitude);
//   }

//   _onMapCreated(GoogleMapController controller) {
//     setState(() {
//       _controller.complete(controller);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fncGetUserLocation();
//     // fncConvertToAddress(kInitialPosition.latitude, kInitialPosition.longitude);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appBar = PreferredSize(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 15),
//         child: AppBar(
//           // primary: false,
//           elevation: 0,
//           backgroundColor: Colors.white,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.grey,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Transform.translate(
//             offset: Offset(-8, 0),
//             child: Container(
//               // height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey),
//               ),
//               // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               child: TextFormField(
//                 textCapitalization: TextCapitalization.words,
//                 controller: textFormcontroller,
//                 onTap: () {
//                   fctGoSearchAddress();
//                 },
//                 readOnly: true,
//                 decoration: const InputDecoration(
//                   hintText: "Search pincode",
//                   contentPadding: EdgeInsets.only(left: 15),
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       preferredSize: const Size.fromHeight(85),
//     );
//     // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: appBar,
//       body: Column(
//         children: [
//           Expanded(
//             child: _initialPosition == null
//                 ? const Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Stack(
//                     children: [
//                       GoogleMap(
//                         myLocationEnabled: true,
//                         myLocationButtonEnabled: false,
//                         compassEnabled: true,
//                         mapType: MapType.normal,
//                         initialCameraPosition: CameraPosition(
//                           target: _initialPosition!,
//                           zoom: 17.4746,
//                         ),
//                         onMapCreated: _onMapCreated,
//                         onCameraMove: (CameraPosition cameraPositiona) {
//                           cameraPosition = cameraPositiona;
//                         },
//                         onCameraIdle: () async {
//                           fncConvertToAddress(cameraPosition!.target.latitude,
//                               cameraPosition!.target.longitude);
//                         },
//                       ),
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 15), //30,
//                           child: SvgPicture.asset('images/location.svg',
//                               height: 35, width: 35),
//                         ),
//                       ),

//                       /////////
//                     ],
//                   ),
//           ),
//           Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(20.0),
//                 topLeft: Radius.circular(20.0),
//               ),
//             ),
//             width: MediaQuery.of(context).size.width,
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const TextInput(
//                         text1: "Delivery Location", colorOfText: Colors.grey),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 5),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // const Icon(Icons.location_on_outlined),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 3.0),
//                             child: Image.asset(
//                               'images/05_CHECKOUT-14.png',
//                               height: 20,
//                               width: 20,
//                             ),
//                           ),
//                           width5,
//                           Expanded(
//                             child: TextInput(
//                               text1: location,
//                               maxLines: 2,
//                             ),
//                           ),
//                           // Column(
//                           //   crossAxisAlignment: CrossAxisAlignment.start,
//                           //   children: [
//                           //     TextInput(text1: location),
//                           //     // TextInput(text1: "Pin: 679332"),
//                           //   ],
//                           // )
//                         ],
//                       ),
//                     ),
//                     CustomButton2(
//                       buttonName: "Confirm Pin Location",
//                       buttonAction: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ScreenMainPage()));
//                       },
//                       color: primaryColor,
//                       height: MediaQuery.of(context).size.height / 5 - 20,
//                       width: MediaQuery.of(context).size.width - 10,
//                     )
//                   ]),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// Future<Null> displayPrediction(Prediction p, BuildContext context) async {
//   GoogleMapsPlaces _places = GoogleMapsPlaces(
//     apiKey: kGoogleApiKey,
//     apiHeaders: await const GoogleApiHeaders().getHeaders(),
//   );
//   PlacesDetailsResponse detail =
//       await _places.getDetailsByPlaceId(p.placeId.toString());
//   // final lat = detail.result.geometry!.location.lat;
//   // final lng = detail.result.geometry!.location.lng;

//   // var snackBar1 = SnackBar(content: Text("${p.description} - $lat/$lng"));
//   // ScaffoldMessenger.of(context).showSnackBar(snackBar1);
//   Navigator.pop(context, detail);
// }

// class CustomSearchScaffold extends PlacesAutocompleteWidget {
//   CustomSearchScaffold({Key? key})
//       : super(
//           key: key,
//           apiKey: kGoogleApiKey,
//           sessionToken: Uuid().generateV4(),
//           language: "en",
//           radius: 100000,
//           strictbounds: false,
//           types: [],
//           components: [
//             Component(Component.country, "IN"),
//             // Component(Component.locality, "Eranhimangad"),
//             // Component(Component.administrativeArea, "Malappuram"),
//             // Component(Component.postalCode, "682302"),
//           ],
//         );

//   @override
//   _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
// }

// final searchScaffoldKey = GlobalKey<ScaffoldState>();

// class _CustomSearchScaffoldState extends PlacesAutocompleteState {
//   @override
//   Widget build(BuildContext context) {
//     final appBar = PreferredSize(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 15),
//         child: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.grey,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Transform.translate(
//             offset: Offset(-8, 0),
//             child: Container(
//               // height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey),
//               ),
//               // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               child: AppBarPlacesAutoCompleteTextField(
//                 textStyle: null,
//                 textDecoration: const InputDecoration(
//                   hintText: "Search for your address",
//                   contentPadding: EdgeInsets.only(left: 15),
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       preferredSize: const Size.fromHeight(85),
//     );
//     final body = PlacesAutocompleteResult(
//       onTap: (p) => displayPrediction(p, context),
//       logo: const SizedBox(),
//     );
//     return Scaffold(
//         key: searchScaffoldKey,
//         backgroundColor: Colors.white,
//         appBar: appBar,
//         body: body);
//   }

//   @override
//   void onResponseError(PlacesAutocompleteResponse response) {
//     super.onResponseError(response);

//     var snackBar2 = SnackBar(content: Text('${response.errorMessage}'));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar2);
//   }
// }

// class Uuid {
//   final Random _random = Random();

//   String generateV4() {
//     // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
//     final int special = 8 + _random.nextInt(4);

//     return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
//         '${_bitsDigits(16, 4)}-'
//         '4${_bitsDigits(12, 3)}-'
//         '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
//         '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
//   }

//   String _bitsDigits(int bitCount, int digitCount) =>
//       _printDigits(_generateBits(bitCount), digitCount);

//   int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

//   String _printDigits(int value, int count) =>
//       value.toRadixString(16).padLeft(count, '0');
// }
