import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps1Page extends StatefulWidget {
  const Maps1Page({super.key});

  @override
  State<Maps1Page> createState() => _Maps1PageState();
}

class _Maps1PageState extends State<Maps1Page> {
  Position? currentPosition;
  Marker? mypositionMarker;

  Future<void> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location Servicde are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permisos denegados");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Los permisos estan dengados permanentementem, no se puede solicitar permisos",
      );
    }
    try {
      Position position = await Geolocator.getCurrentPosition();
      print("lat: ${position.latitude} - ${position.longitude}");
      currentPosition = position;
      mypositionMarker = Marker(
        markerId: MarkerId("myPos"),
        position: LatLng(position.latitude, position.longitude),
      );
      setState(() {});
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: currentPosition == null
            ? CircularProgressIndicator()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentPosition!.latitude,
                    currentPosition!.longitude,
                  ),
                  zoom: 15,
                ),
                markers: {
                  mypositionMarker!,
                  // Marker(
                  //   markerId: MarkerId("1"),
                  //   position: LatLng(
                  //     currentPosition!.latitude,
                  //     currentPosition!.longitude,
                  //   ),
                  // ),
                },
              ),
      ),
    );
  }
}
