import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMyWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool? mapbutton;
  static final GlobalKey<_MapMyWidgetState> globalKey = GlobalKey();

  MapMyWidget({required this.latitude, required this.longitude, this.mapbutton})
      : super(key: globalKey);
  // const MapMyWidget(
  //     {super.key, required this.latitude, required this.longitude});

// super(key: globalKey);

  @override
  State<MapMyWidget> createState() => _MapMyWidgetState();
}

class _MapMyWidgetState extends State<MapMyWidget>
    with AutomaticKeepAliveClientMixin {
  GoogleMapController? _controllerMapAdd;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    if (_controllerMapAdd != null) _controllerMapAdd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Consumer<LocationButtonProvider>(
    //   builder: (context, locationProvider, child) {
    return Stack(
      children: [
        GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled:
              widget.mapbutton == null ? true : widget.mapbutton!,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 16,
          ),
          zoomGesturesEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          indoorViewEnabled: true,
          mapToolbarEnabled: true,
          // onCameraIdle: () {
          //   locationProvider.dragableAddress();
          // },
          // onCameraMove: ((_position) {
          //   locationProvider.updatePosition(_position);
          // }),
          onMapCreated: (GoogleMapController controller) {
            _controllerMapAdd = controller;
            if (_controllerMapAdd != null) {
              _controllerMapAdd!.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(widget.latitude, widget.longitude),
                      zoom: 17)));
              // locationProvider.getCurrentLocation(
              //     mapController: _controllerMapAdd);
            }
          },
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30), //30,
            child:
                SvgPicture.asset('images/location.svg', height: 35, width: 35),
          ),
        ),
      ],
    );
    // },
    // );
  }

  void methodA() {
    setState(() {});
  }
}
