import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final List<Map<String, dynamic>> clityList = const [
    {
      "address": "'موقع فارمسي زول'",
      "id": "jaipur_01",
      "image":
          "https://i.pinimg.com/originals/b7/3a/13/b73a132e165978fa07c6abd2879b47a6.png",
      "lat": 31.264498691216428,
      "lng": 32.30115704186617,
      "name": "'موقع فارمسي زول'",
      "phone": "+201064422809",
      "region": "North Africa"
    },
    {
      "address": "'موقع فارمسي زول'",
      "id": "jaipur_01",
      "image":
          "https://i.pinimg.com/originals/b7/3a/13/b73a132e165978fa07c6abd2879b47a6.png",
      "lat": 33.264535374410887,
      "lng": 33.264535374410887,
      "name": "'موقع فارمسي زول'",
      "phone": "+201064422809",
      "region": "North Africa"
    }
  ];

  List<Marker> markers = [
    Marker(
      markerId: MarkerId("'موقع فارمسي زول'"),
      position: LatLng(33.264535374410887, 33.264535374410887),
      infoWindow: InfoWindow(onTap: () {}, title: 'موقع فارمسي زول'),
      onTap: () {
        print("Clicked on marker");
      },
    ),
  ];

  launchMap(lat, long) {
    MapsLauncher.launchCoordinates(lat, long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PharmaColor,
        elevation: 10,
        title: const Text('موقع فارمسي زول'),
      ),
      body: GoogleMap(
          onMapCreated: (GoogleMapController googleMapController) {},
          initialCameraPosition: CameraPosition(
            target: LatLng(clityList[0]['lat'], clityList[0]['lng']),
            zoom: 4.8,
          ),
          markers: markers.toSet()),
    );
  }
}
