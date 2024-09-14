// ignore_for_file: unnecessary_brace_in_string_interps
import 'dart:convert';
import 'dart:developer';

import 'package:fazzmi/presentaion/delivery_location/screenPinLocation.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../core/constants/constants.dart';
import '../model/addressModel/addressModel.dart';
import '../model/postalCodeModel/postalCodeModel.dart';

const kGoogleApiKey = "AIzaSyB3oZQWckR628FsRz3e15qcVbkLmWDT3VE";

class LocationButtonProvider with ChangeNotifier {
  final box = GetStorage();

  /// LOCATION INFORMATION
  List<dynamic>? _locationInformation;

  /// get postal code list variable declaration
  PostalCodeModel? _postalCodeList;
  PostalCodeModel? get postalCodeList => _postalCodeList;

  // LocationButtonProvider(BuildContext buildContext);
  BuildContext context;
  LocationButtonProvider(this.context);
  ScrollController _controller = new ScrollController();
  List<dynamic>? get locationInformation => _locationInformation;

  //JkWorkz Commented because it isn't being used
  // String _currentSelected = "Select address";
  // String get currentSelected => _currentSelected;

  String _selectedAddress = '';
  String get selectedAddress => _selectedAddress; // Used in screenPinLocation

  bool _addressAvailable = false;
  bool get addressAvailable => _addressAvailable;

  set addressAvailable(bool value) {
    _addressAvailable = value;
    notifyListeners();
  }

  List<String> fazzmiAvailableAreas = [];

  // getAddress() {
  //   return _address;
  // }

  int? selectedIndex = 0;

  /*
  |-----------------
  |Location from map
  |-----------------  
  */

  Position _position = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    speed: 1,
    speedAccuracy: 1,
    altitudeAccuracy: 1,
    headingAccuracy: 1,
  );
  bool _loading = false;
  bool get loading => _loading;

  Position get position => _position;
  // SelectedPlace _address = SelectedPlace();

  // SelectedPlace get address => _address;

  String gMapsPlusCode = "";
  String gMapsPinCode = "";
  String gMapsStreet = "";
  String? gMapsLocality = "";
  String? gMapsSubLocality = "";
  late Placemark gMapsAddress;
  String gMapsAddressFormated = "";
  dynamic gMapsLatitude = "";
  dynamic gMapsLongitude = "";

  setLoading(value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> getCurrentLocation({GoogleMapController? mapController}) async {
    setLoading(true);

    // Do not know the variables importance nor the relevance here..
    addressAvailable = false;

    log("addressAvailable 1 ======================== getCurrentLocation");
    log(addressAvailable ? "TRUE" : "FALSE");
    log("addressAvailable 1 ======================== getCurrentLocation");

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      Position newLocalData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      await getFazzmiAvailableAreas();

      if (mapController != null) {
        /// Move the map to current location
        mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(newLocalData.latitude, newLocalData.longitude),
            zoom: 17)));

        _position = newLocalData;

        await fetchAddressFromCoordinates(
            newLocalData.latitude, newLocalData.longitude);
      }
    } catch (e) {}
    setLoading(false);
  }

  void updateMapPosition(CameraPosition position) async {
    _position = Position(
      latitude: position.target.latitude,
      longitude: position.target.longitude,
      timestamp: DateTime.now(),
      heading: 1,
      accuracy: 1,
      altitude: 1,
      speedAccuracy: 1,
      speed: 1,
      altitudeAccuracy: 1,
      headingAccuracy: 1,
    );
    setLoading(true);
  }

  // End address position
  Future<dynamic> mapDragIdleCallback() async {
    addressAvailable = false;

    log("addressAvailable 1 ======================== mapDragIdleCallback");
    log(addressAvailable ? "TRUE" : "FALSE");
    log("addressAvailable 1 ======================== mapDragIdleCallback");

    try {
      return await fetchAddressFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      // setLoading(false);
    }
    return false;
  }

  getAutocompleteLocation(
      {GoogleMapController? mapController,
      required CameraPosition position}) async {
    if (mapController != null) {
      //Aswathy  hto be made
      mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.target.latitude, position.target.longitude),
          zoom: 16)));

      updateMapPosition(position);
    }
  }

  readLocation() async {
    _selectedAddress = await box.read('locationValue');
    notifyListeners();
  }

  /* ------------------------------*/

  setSelectedLocation({region, city, area, street, postcode, index}) {
    selectedIndex = index;
    _selectedAddress = '${street},${region}';
    box.write('locationValue', _selectedAddress);
    box.write("locationSingleAddress", _selectedAddress);
    box.write("actualpinCode", postcode);

    notifyListeners();
  }

  Future<dynamic> fetchAddressFromCoordinates(lat, long) async {
    bool addressSelectStat = false;
    String latlng = '$lat,$long';
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    gMapsPlusCode = placemarks.first.name ?? '';
    gMapsPinCode = placemarks.first.postalCode ?? '';
    gMapsStreet = placemarks.first.street ?? '';

    gMapsAddress = placemarks[1];
    // Placemark placemarksAdres = placemarks[1];
    gMapsLatitude = lat;
    gMapsLongitude = long;

    gMapsLocality = (gMapsAddress.locality!.isEmpty)
        ? gMapsAddress.administrativeArea
        : gMapsAddress.locality;

    gMapsSubLocality = (gMapsAddress.subLocality!.isEmpty)
        ? gMapsAddress.locality
        : gMapsAddress.subLocality;

    gMapsAddressFormated = "";

    //JkWorkz Commented because it isn't being used
    //_currentSelected = box.read("locationSingleAddress");

    notifyListeners();

    log("gMapsPinCode 2 ========================");
    log(gMapsPinCode);
    log("gMapsPinCode 2 ========================");

    if (fazzmiAvailableAreas.contains(gMapsPinCode)) {
      addressSelectStat = true;
      addressAvailable = true;

      log("addressAvailable 2 ========================");
      log(addressAvailable ? "TRUE" : "FALSE");
      log("addressAvailable 2 ========================");

      var addressData = await fetchPlaceDetailsByLatlng(latlng);

      if (addressData != null) {
        gMapsAddressFormated = addressData['results'][0]['formatted_address'];

        if (gMapsPlusCode.length == 8 ||
            gMapsAddressFormated.contains(gMapsPlusCode)) {
          gMapsAddressFormated = convertAddress(
              plusCode: gMapsPlusCode, formatedAdd: gMapsAddressFormated);
        }

        // _selectedAddress = gMapsAddressFormated;

        // box.write('locationValue', gMapsAddressFormated);

        //JkWorkz Commented because it isn't being used
        // storeAddress(placemarks.first);
      }
    } else {
      _selectedAddress = '';
      addressAvailable = false;
      addressSelectStat = false;
    }

    setLoading(false);
    notifyListeners();
    return addressSelectStat;
  }

  //JkWorkz Commented because it isn't being used
  // storeAddress(address) {
  //   _address = SelectedPlace(
  //       administrativeArea: address!.administrativeArea,
  //       country: address.country,
  //       isoCountryCode: address.isoCountryCode,
  //       name: address.name,
  //       locality: address.locality,
  //       postalCode: address.postalCode,
  //       street: address.street,
  //       subAdministrativeArea: address.administrativeArea,
  //       subThoroughfare: address.subThoroughfare,
  //       thoroughfare: address.thoroughfare,
  //       subLocality: address.subLocality,
  //       latitude: _position.latitude,
  //       longitude: _position.longitude);
  //   notifyListeners();
  // }

  /// Fetch a location details from Google Maps API using Latitude & Longitude
  Future<dynamic> fetchPlaceDetailsByLatlng(String latlng) async {
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latlng&key=$kGoogleApiKey'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return 'Something went wrong. Please try again.';
      }
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Fetch fazzmiAvailableAreas From the server
  Future<dynamic> getFazzmiAvailableAreas() async {
    try {
      final response = await http.get(Uri.parse(
          'https://staging.fazzmi.com/rest/default/V1/fazmmi-apis/availablepostcode'));

      if (response.statusCode == 200) {
        var jsonMap = jsonDecode(response.body);

        var data = jsonMap['data'] as List;

        // List<String> listOfPostalCode = [];

        data.removeAt(2);
        data.removeAt(2);
        data.removeAt(2);

        data.map((e) {
          fazzmiAvailableAreas.add(e['postcode']);
        }).toList();

        print("data ==================");
        print(data);
        print("data ==================");

        return data;
      } else {
        return 'Something went wrong. Please try again.';
      }
    } catch (e) {
      return 'Something went wrong. Please try again.';
    }
  }

  // WIDGET CODE STARTS HERE

  /// Dropdown present on the HomeScreen App Bar
  locationSelectDropdown(BuildContext context) {
    var token = box.read("token");

    return InkWell(
        onTap: token == null
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PinLocationScreen()));
              }
            : () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    )),
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Container(
                          // height: 300,
                          padding: const EdgeInsets.only(bottom: 25),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          // alignment: Alignment.center,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 12, top: 20, bottom: 28, right: 8),
                                child: TextInput(
                                    weight: FontWeight.bold,
                                    text1: "Choose delivery location",
                                    size: 20,
                                    colorOfText: Colors.black),
                              ),
                              FutureBuilder<List<AddressData>?>(
                                  future: ApiServices().getAddressBook(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        controller: _controller,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          var item = snapshot.data![index];
                                          return InkWell(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 20),
                                                  child: Icon(Icons
                                                      .location_on_outlined),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      120,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: TextInput(
                                                          text1:
                                                              item.addressType ??
                                                                  '',
                                                          weight:
                                                              FontWeight.bold,
                                                          colorOfText:
                                                              Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                          "${item.street},${item.city},${item.region},\n"
                                                          "Pin:${item.postcode}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      15)),
                                                      // Text(
                                                      //   '${shippingbuilding},${shippingCity}',
                                                      //   style: const TextStyle(
                                                      //       color: Colors.grey,
                                                      //       fontSize: 15),
                                                      // ),
                                                      // Text(
                                                      //   '${item.region},${item.postcode}',
                                                      //   style: const TextStyle(
                                                      //       color: Colors.grey,
                                                      //       fontSize: 15),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                Radio<int>(
                                                  //ctiveColor: primaryColor,
                                                  value: index,
                                                  groupValue: selectedIndex,
                                                  onChanged: (value) {
                                                    setSelectedLocation(
                                                      region: item.region,
                                                      city: item.area,
                                                      street: item.street,
                                                      postcode: item.postcode,
                                                      index: value,
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              setSelectedLocation(
                                                region: item.region,
                                                street: item.street,
                                                postcode: item.postcode,
                                                index: index,
                                              );
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset("images/pin.png")),
                                    ),
                                    width20,
                                    InkWell(
                                      onTap: () {
                                        if (selectedIndex != null) {
                                          // Reset selected radio item
                                          setSelectedLocation(
                                            region: null,
                                            street: null,
                                            postcode: null,
                                            index: null,
                                          );
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PinLocationScreen(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                120,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            TextInput(
                                                text1:
                                                    "Enter an Indian pincode",
                                                weight: FontWeight.bold,
                                                colorOfText: Colors.black),
                                            TextInput(
                                              text1: "Choose pincode on map",
                                              colorOfText: Colors.grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (0 == 1)
                                      Checkbox(
                                        activeColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        value: false,
                                        onChanged: (value) {},
                                      ),
                                  ],
                                ),
                              ),
                              height40,
                              height10,
                            ],
                          ),
                        ),
                      );
                    });
              },
        child: Container(
          color: Colors.transparent,
          // width: 220,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                box.read("locationSingleAddress") ?? "Select Address",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -4),
                child: const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: primaryColor,
                ),
              )
            ],
          ),
        ));
  }

  convertAddress({removeIndex, formatedAdd, plusCode}) {
    List<String> list = formatedAdd.split(RegExp(r',\s'));

    list.remove(plusCode);
    return list.join(",\t");
  }
}
