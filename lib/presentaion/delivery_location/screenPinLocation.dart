import 'dart:math';

import 'package:fazzmi/core/constants/boxvariables.dart';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/mainPage/screen_main_page.dart';
import 'package:fazzmi/provider/locationButtonProvider.dart';
import 'package:fazzmi/widgets/customButton2.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const kGoogleApiKey = "AIzaSyB3oZQWckR628FsRz3e15qcVbkLmWDT3VE";

class PinLocationScreen extends StatefulWidget {
  const PinLocationScreen({Key? key, this.isReturnWithAdd = false})
      : super(key: key);
  final bool isReturnWithAdd;

  @override
  State<PinLocationScreen> createState() => _PinLocationScreenState();
}

class _PinLocationScreenState extends State<PinLocationScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  GoogleMapController? _controller;
  List addressList = [];
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  var iscomming = true;

  notAvailable() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Oops!!"),
          content:
              const Text("Oh no! This location is outside of our service area"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      preferredSize: const Size.fromHeight(85),
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Transform.translate(
            offset: const Offset(-45, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: addressController,
                onTap: () async {
                  PlacesDetailsResponse? detail = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomSearchScaffold()));

                  if (detail != null && detail.status == "OK") {
                    final selectedLocation = detail.result.geometry;
                    setState(() {
                      addressController.text = detail.result.name;
                    });

                    Provider.of<LocationButtonProvider>(context, listen: false)
                        .getAutocompleteLocation(
                      mapController: _controller,
                      position: CameraPosition(
                        target: LatLng(selectedLocation!.location.lat,
                            selectedLocation.location.lng),
                        zoom: 17,
                      ),
                    );
                  }
                },
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: "Search pincodes",
                  contentPadding: EdgeInsets.only(left: 15),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Consumer<LocationButtonProvider>(
        builder: (context, locationProvider, child) => Column(children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) async {
                    _controller = controller;
                    if (_controller != null) {
                      await locationProvider.getCurrentLocation(
                          mapController: _controller);
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      locationProvider.position.latitude,
                      locationProvider.position.longitude,
                    ),
                    // zoom: 16,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  indoorViewEnabled: true,
                  mapToolbarEnabled: true,
                  onCameraIdle: () async {
                    await locationProvider.mapDragIdleCallback();
                    // bool isAvailable = await locationProvider.mapDragIdleCallback();

                    // if (!isAvailable && !locationProvider.loading) {
                    //   notAvailable();
                    // }
                  },
                  onCameraMove: ((_position) {
                    addressList.clear();
                    locationProvider.updateMapPosition(_position);
                  }),
                ),
                Center(
                  child: locationProvider.loading
                      ? const CircularProgressIndicator()
                      : null,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SvgPicture.asset('images/location.svg',
                      height: 35, width: 35),
                ),
              ],
            ),
          ),
          buildBottomSection(context, locationProvider),
        ]),
      ),
      floatingActionButton: Consumer<LocationButtonProvider>(
          builder: (context, locationProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 70),
          child: SizedBox(
            height: 40,
            width: 40,
            child: FloatingActionButton(
                backgroundColor: primaryColor,
                child: const Icon(Icons.location_searching),
                onPressed: (() async {
                  if (_controller != null) {
                    await locationProvider.getCurrentLocation(
                        mapController: _controller);
                  }
                })),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  buildBottomSection(
      BuildContext context, LocationButtonProvider locationProvider) {
    return Consumer<LocationButtonProvider>(
      builder: (context, providerValue, child) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          height: providerValue.addressAvailable
              ? MediaQuery.of(context).size.height * 0.22
              : 130,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextInput(text1: "Delivery Location", colorOfText: Colors.grey),
              if (providerValue.addressAvailable)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Icon(Icons.location_on_outlined),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Image.asset(
                          'images/05_CHECKOUT-14.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      width5,
                      Expanded(
                        child: TextInput(
                          text1: providerValue.selectedAddress,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              height20,
              CustomButton2(
                buttonName: "Confirm Pin Location",
                buttonAction: () {
                  if (providerValue.addressAvailable) {
                    changeLocation(providerValue);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScreenMainPage(),
                      ),
                    );
                  } else {
                    notAvailable();
                  }
                },
                color: primaryColor,
                height: 40,
                width: MediaQuery.of(context).size.width - 10,
              )
            ]),
          ),
        );
      },
    );
  }

  changeLocation(locData) {
    box.write("locationSingleAddress", '${locData.gMapsSubLocality}');
    box.write("addressDetails", locData.gMapsAddress);
    box.write("selectedPinCode", locData.gMapsPinCode);
    box.write("selectedStreet", locData.gMapsStreet);
    box.write("selectedLocality", locData.gMapsLocality);
    box.write("selectedSubLocality", locData.gMapsSubLocality);
    box.write("lattitude", locData.gMapsLatitude);
    box.write("longitude", locData.gMapsLongitude);
    box.write("actualpinCode", locData.gMapsPinCode);

    // locData._selectedAddress = locData.gMapsAddressFormated;
    box.write('locationValue', locData.gMapsAddressFormated);
  }
}

//auto complete class widget

Future<dynamic> displayPrediction(Prediction p, BuildContext context) async {
  GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: kGoogleApiKey,
    apiHeaders: await const GoogleApiHeaders().getHeaders(),
  );
  PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId.toString());
  Navigator.pop(context, detail);
}

class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold({Key? key})
      : super(
          key: key,
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          radius: 100000,
          strictbounds: false,
          types: [],
          components: [
            Component(Component.country, "IN"),
          ],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Transform.translate(
            offset: Offset(-8, 0),
            child: Container(
              // height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: AppBarPlacesAutoCompleteTextField(
                cursorColor: Colors.amber,
                textStyle: null,
                textDecoration: const InputDecoration(
                  hintText: "Search for your pincode",
                  contentPadding: EdgeInsets.only(left: 15),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
      preferredSize: const Size.fromHeight(85),
    );
    final body = PlacesAutocompleteResult(
      onTap: (p) => displayPrediction(p, context),
      logo: const SizedBox(),
    );
    return Scaffold(
        key: searchScaffoldKey,
        backgroundColor: Colors.white,
        appBar: appBar,
        body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);

    var snackBar2 = SnackBar(content: Text('${response.errorMessage}'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar2);
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
