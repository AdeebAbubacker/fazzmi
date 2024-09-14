// // ignore_for_file: unnecessary_brace_in_string_interps
// import 'dart:convert';
// import 'dart:developer';
// import 'package:fazzmi/model/location/selectedPlace.dart';
// import 'package:fazzmi/presentaion/delicery_location/screenPinLocation.dart';
// import 'package:fazzmi/services/api_services.dart';
// import 'package:fazzmi/widgets/textInput.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../core/constans/constants.dart';
// import '../model/addressModel/addressModel.dart';

// import 'package:http/http.dart' as http;

// import '../model/postalCodeModel/postalCodeModel.dart';

// const kGoogleApiKey = "AIzaSyB3oZQWckR628FsRz3e15qcVbkLmWDT3VE";

// class LocationButtonProvider with ChangeNotifier {
//   final box = GetStorage();

//   /// LOCATION INFORMATION
//   List<dynamic>? _locationInformation;

//   /// get postal code list variable declaration
//   PostalCodeModel? _postalCodeList;
//   PostalCodeModel? get postalCodeList => _postalCodeList;

//   // LocationButtonProvider(BuildContext buildContext);
//   BuildContext context;
//   LocationButtonProvider(this.context);

//   List<dynamic>? get locationInformation => _locationInformation;

//   String _currentSelected = "Select address";
//   String get currentSelected => _currentSelected;

//   String _selected = '';
//   String get selected => _selected;

//   bool _addAvailable = false;
//   bool get addressAvailable => _addAvailable;

//   set addressAvailable(bool value) {
//     _addAvailable = value;
//     notifyListeners();
//   }

//   getAddress() {
//     return _address;
//   }

//   int? selectedIndex;
//   /*
//   |-----------------
//   |Location from map
//   |-----------------  
//   */

//   Position _position = Position(
//     longitude: 0.0,
//     latitude: 0.0,
//     timestamp: DateTime.now(),
//     accuracy: 1,
//     altitude: 1,
//     heading: 1,
//     speed: 1,
//     speedAccuracy: 1,
//   );
//   bool _loading = false;
//   bool get loading => _loading;

//   Position get position => _position;
//   SelectedPlace _address = SelectedPlace();

//   SelectedPlace get address => _address;

//   setLoading(value) {
//     _loading = value;
//     notifyListeners();
//   }

//   Future<void> getCurrentLocation({GoogleMapController? mapController}) async {
//     setLoading(true);

//     addressAvailable = true;
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return Future.error('Location permissions are denied');
//         }
//       }
//       // if (_selected != '') {
//       Position newLocalData = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       dynamic postalcodes = await getPostalCodes();

//       if (mapController != null) {
//         mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target: LatLng(newLocalData.latitude, newLocalData.longitude),
//             zoom: 17)));
//         _position = newLocalData;

//         await findAddress(
//             lat: newLocalData.latitude, long: newLocalData.longitude);
//       }
//       // }
//     } catch (e) {}
//     setLoading(false);
//   }

//   void updatePosition(CameraPosition position) async {
//     _position = Position(
//       latitude: position.target.latitude,
//       longitude: position.target.longitude,
//       timestamp: DateTime.now(),
//       heading: 1,
//       accuracy: 1,
//       altitude: 1,
//       speedAccuracy: 1,
//       speed: 1,
//     );
//     setLoading(true);
//   }

//   // End address position
//   Future<dynamic> dragableAddress() async {
//     // setLoading(true);
//     bool res = false;
//     try {
//       res =
//           await findAddress(lat: _position.latitude, long: _position.longitude);

//       // setLoading(false);
//     } catch (e) {
//       // setLoading(false);
//     }
//     return res;
//   }

//   getAutocompleteLocation(
//       {GoogleMapController? mapController,
//       required CameraPosition position}) async {
//     if (mapController != null) {
//       mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           target: LatLng(position.target.latitude, position.target.longitude),
//           zoom: 16)));
//       updatePosition(position);
//     }
//   }

//   readLocation() async {
//     _selected = await box.read('locationValue');
//     notifyListeners();
//   }

//   /* ------------------------------*/

//   setSelectedLocation({street, subAdministrativeArea, postcode, index = null}) {
//     selectedIndex = index;
//     _selected = '${street}, ${subAdministrativeArea}';
//     box.write('locationValue', _selected);

//     notifyListeners();
//   }

//   List<String> postalCode = [
//     // '682301',
//     // '682302',
//     // '682303',
//     // '673633',
//     // '676525',
//     // '673641',
//     // '679357',
//     // '679322',
//     // '679339'
//   ];

//   Future<dynamic> findAddress({lat, long}) async {
//     String latlng = '$lat,$long';
//     List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

//     String plusCode = placemarks.first.name ?? '';
//     String pinCode = placemarks.first.postalCode ?? '';
//     String street = placemarks.first.street ?? '';

//     Placemark placemarksAdres = placemarks[1];
//     String? subLocality = (placemarksAdres.subLocality!.isEmpty)
//         ? placemarksAdres.locality
//         : placemarksAdres.subLocality;

//     String? locality = (placemarksAdres.locality!.isEmpty)
//         ? placemarksAdres.administrativeArea
//         : placemarksAdres.locality;

//     var _curenttSelected = '${subLocality}';
//     box.write("locationSingleAddress", _curenttSelected);
//     box.write("addressDetails", placemarksAdres);

//     box.write("selectedPinCode", pinCode);
//     box.write("selectedStreet", street);
//     box.write("selectedLocality", locality);
//     box.write("selectedSubLocality", subLocality);
//     box.write("lattitude", lat);
//     box.write("longitude", long);

//     _currentSelected = box.read("locationSingleAddress");

//     notifyListeners();

//     if (postalCode.contains(pinCode)) {
//       addressAvailable = true;

//       await box.write("actualpinCode", pinCode);

//       var addressData = await fetchPlaceDetailsByLatlng(latlng);
//       if (addressData != null) {
//         String formatedAdd = addressData['results'][0]['formatted_address'];
//         if (plusCode.length == 8 || formatedAdd.contains(plusCode)) {
//           formatedAdd =
//               convertAddress(plusCode: plusCode, formatedAdd: formatedAdd);
//         }
//         _selected = formatedAdd;
//         box.write('locationValue', formatedAdd);
//         storeAddress(placemarks.first);
//       }
//     } else {
//       _selected = '';
//       addressAvailable = false;
//     }

//     setLoading(false);
//     notifyListeners();
//     return _addAvailable;
//   }

//   storeAddress(address) {
//     _address = SelectedPlace(
//         administrativeArea: address!.administrativeArea,
//         country: address.country,
//         isoCountryCode: address.isoCountryCode,
//         name: address.name,
//         locality: address.locality,
//         postalCode: address.postalCode,
//         street: address.street,
//         subAdministrativeArea: address.administrativeArea,
//         subThoroughfare: address.subThoroughfare,
//         thoroughfare: address.thoroughfare,
//         subLocality: address.subLocality,
//         latitude: _position.latitude,
//         longitude: _position.longitude);
//     notifyListeners();
//   }

// //get actual address
//   Future<dynamic> fetchPlaceDetailsByLatlng(String latlng) async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latlng&key=$kGoogleApiKey'));
//       if (response.statusCode == 200) {
//         var jsonMap = jsonDecode(response.body);

//         return jsonMap;
//       } else {
//         return 'Something went wrong. Please try again.';
//       }
//     } catch (e) {
//       return 'Something went wrong. Please try again.';
//     }
//   }

//   // get postalCodes

//   Future<dynamic> getPostalCodes() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://staging.fazzmi.com/rest/default/V1/fazmmi-apis/availablepostcode'));

//       if (response.statusCode == 200) {
//         var jsonMap = jsonDecode(response.body);

//         var data = jsonMap['data'] as List;

//         List<String> listOfPostalCode = [];
//         data.map((e) {
//           listOfPostalCode.add(e['postcode']);
//         }).toList();
//         postalCode = listOfPostalCode;

//         return jsonMap;
//       } else {
//         return 'Something went wrong. Please try again.';
//       }
//     } catch (e) {
//       return 'Something went wrong. Please try again.';
//     }
//   }

//   //widget starts

//   locationButton(BuildContext context) {
//     var token = box.read("token");
//     return InkWell(
//         onTap: token == null
//             ? () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const PinLocationScreen()));
//               }
//             : () {
//                 showModalBottomSheet(
//                     shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(25.0),
//                     )),
//                     context: context,
//                     builder: (context) {
//                       return Container(
//                         // height: 300,
//                         padding: const EdgeInsets.only(bottom: 25),
//                         decoration: const BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20))),
//                         // alignment: Alignment.center,
//                         child: Wrap(
//                           // crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Padding(
//                               padding: EdgeInsets.only(
//                                   left: 12, top: 20, bottom: 28, right: 8),
//                               child: TextInput(
//                                   weight: FontWeight.bold,
//                                   text1: "Choose delivery location",
//                                   size: 20,
//                                   colorOfText: Colors.black),
//                             ),
//                             FutureBuilder<List<AddressData>?>(
//                                 future: ApiServices().getAddressBook(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.hasData) {
//                                     return ListView.separated(
//                                         shrinkWrap: true,
//                                         itemCount: snapshot.data!.length,
//                                         separatorBuilder: (context, int) {
//                                           return const Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Divider(),
//                                           );
//                                         },
//                                         itemBuilder: (context, index) {
//                                           var item = snapshot.data![index];
//                                           return InkWell(
//                                               child: Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   const Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 8, right: 20),
//                                                     child: Icon(
//                                                       Icons
//                                                           .location_on_outlined,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width -
//                                                             120,
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Align(
//                                                           alignment:
//                                                               Alignment.topLeft,
//                                                           child: TextInput(
//                                                               text1:
//                                                                   item.addressType ??
//                                                                       'Home',
//                                                               weight: FontWeight
//                                                                   .bold,
//                                                               colorOfText:
//                                                                   Colors.black),
//                                                         ),
//                                                         Text(
//                                                           '${item.street}, ${item.city},${item.postcode}',
//                                                           style:
//                                                               const TextStyle(
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   fontSize: 15),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Checkbox(
//                                                     activeColor: primaryColor,
//                                                     shape:
//                                                         RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         100)),
//                                                     value: selectedIndex != null
//                                                         ? index == selectedIndex
//                                                             ? true
//                                                             : false
//                                                         : false,
//                                                     onChanged: (value) {},
//                                                   )
//                                                 ],
//                                               ),
//                                               onTap: () {
//                                                 // changelocation(index: index);
//                                                 // selectedIndex = index;
//                                                 setSelectedLocation(
//                                                     street: item.street,
//                                                     subAdministrativeArea:
//                                                         item.city,
//                                                     postcode: item.postcode,
//                                                     index: index);
//                                                 Navigator.of(context).pop();
//                                               });
//                                         });
//                                   } else {
//                                     return const Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   }
//                                 }),
//                             const Divider(),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 3),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 8),
//                                     child: SizedBox(
//                                         height: 20,
//                                         width: 20,
//                                         child: Image.asset("images/pin.png")),
//                                   ),
//                                   width20,
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const PinLocationScreen()));
//                                     },
//                                     child: SizedBox(
//                                       width: MediaQuery.of(context).size.width -
//                                           120,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: const [
//                                           TextInput(
//                                               text1: "Enter an Indian pincode",
//                                               weight: FontWeight.bold,
//                                               colorOfText: Colors.black),
//                                           TextInput(
//                                             text1: "Choose pincode on map",
//                                             colorOfText: Colors.grey,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   if (0 == 1)
//                                     Checkbox(
//                                       activeColor: primaryColor,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(100)),
//                                       value: false,
//                                       onChanged: (value) {},
//                                     )
//                                 ],
//                               ),
//                             ),
//                             height40,
//                             height10,
//                           ],
//                         ),
//                       );
//                     });
//               },
//         child: Container(
//           color: Colors.transparent,
//           // width: 220,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 box.read("locationSingleAddress") ?? "SelectAddres",
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               Transform.translate(
//                 offset: const Offset(0, -4),
//                 child: const Icon(
//                   Icons.keyboard_arrow_down_outlined,
//                   color: primaryColor,
//                 ),
//               )
//             ],
//           ),
//         )

//         /* Container(
//         color: Colors.transparent,
//         width: 250,
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 _currentSelected,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ),
//             Transform.translate(
//               offset: const Offset(-10, 0),
//               child: const Icon(
//                 Icons.keyboard_arrow_down_outlined,
//                 color: primaryColor,
//               ),
//             )
//           ],
//         ),
//       ),*/
//         );
//   }

//   convertAddress({removeIndex, formatedAdd, plusCode}) {
//     List<String> list = formatedAdd.split(RegExp(r',\s'));

//     list.remove(plusCode);
//     return list.join(",\t");
//   }
// }
