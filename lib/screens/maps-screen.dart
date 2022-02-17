import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];
  MarkerId? selectedMarker;
  int _markerIdCounter = 1;
  LatLng? markerPosition;
  CameraPosition? userLocation;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();

    _determinePosition().then((pos) {
      print('Position: $pos');

      setState(() {
        userLocation = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(pos.latitude, pos.longitude),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414);
      });
      _goToUserLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: _kGooglePlex,
        markers: markers.toSet(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<void> _goToUserLocation() async {
    if (userLocation != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(userLocation!));

      // List gps = [
      //   LatLng(37.43296265331129, -122.08832357078792),
      //   LatLng(37.43296265331129, -122.08832357078792),
      //   LatLng(37.43296265331129, -122.08832357078792),
      // ];
      _addMarker(userLocation?.target.latitude ?? 0,
          userLocation?.target.longitude ?? 0);
      _addMarker(37.43296265331129, -122.08832357078792);
      // _addAllMarkers(gps);
    }
  }

  void _addMarker(double lat, double lng) {
    final String markerIdVal = '${Random().nextDouble()}';
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        lat + sin(_markerIdCounter * pi / 6.0) / 20.0,
        lng + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
    );

    markers.add(marker);
    setState(() {});
  }

  void _addAllMarkers(List<LatLng> gps) {
    gps.forEach((val) {
      final String markerIdVal = '${Random().nextDouble()}';
      final MarkerId markerId = MarkerId(markerIdVal);
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          val.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
          val.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
        ),
        infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      );

      markers.add(marker);
    });
    setState(() {});
  }

  void _remove(MarkerId markerId) {
    markers.removeWhere((element) => element.markerId == markerId);
    setState(() {});
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
