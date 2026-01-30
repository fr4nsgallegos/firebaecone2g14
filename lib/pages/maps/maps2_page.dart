import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebaseconn2g14/models/home_controller.dart';
import 'package:firebaseconn2g14/pages/maps/place_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps2Page extends StatefulWidget {
  @override
  State<Maps2Page> createState() => _Maps2PageState();
}

class _Maps2PageState extends State<Maps2Page> {
  Set<Marker> markers = {};

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final _mapController = HomeController();

  Future<void> addMarkers() async {
    Set<Marker> auxMarkers = Set();
    BitmapDescriptor iconMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      "assets/markers/green.png",
    );

    // Método1
    // auxMarkers = places.map((place) {
    //   return Marker(
    //     markerId: MarkerId(place.id.toString()),
    //     position: place.position,
    //     icon: iconMarker,
    //     infoWindow: InfoWindow(title: place.name, snippet: place.services),
    //   );
    // }).toSet();

    // Método 2
    places.forEach((place) {
      auxMarkers.add(
        Marker(
          markerId: MarkerId(place.id.toString()),
          position: place.position,
          icon: iconMarker,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                width: 250,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      child: Image.network(
                        place.urlImage,
                        width: 250,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(place.services, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              place.position,
            );
          },
        ),
      );
    });

    markers = auxMarkers;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) async {
              _customInfoWindowController.googleMapController = controller;
              _mapController.onMapCreated(controller);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(-12.072985897499475, -77.07161148449406),
              zoom: 18,
            ),
            markers: markers,
            onTap: (LatLng position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 180,
            width: 250,
            offset: 50,
          ),
        ],
      ),
    );
  }
}
