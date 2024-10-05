import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Distance extends StatefulWidget {
  @override
  _DistanceState createState() => _DistanceState();
}

class _DistanceState extends State<Distance> {
  String startArea = "";
  String destinationArea = "";

  double distanceInKm = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Distance between addresses:'),
            Text('$distanceInKm km'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateDistance(startArea, destinationArea);
              },
              child: Text('Calculate Distance'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> calculateDistance(String startArea, String destinationArea) async {
    try {
      // Geocode start and destination areas to get their coordinates
      List<Location> startLocations = await locationFromAddress(startArea);
      List<Location> destinationLocations = await locationFromAddress(destinationArea);

      // Extract coordinates from the locations
      double startLatitude = startLocations[0].latitude!;
      double startLongitude = startLocations[0].longitude!;
      double destinationLatitude = destinationLocations[0].latitude!;
      double destinationLongitude = destinationLocations[0].longitude!;

      // Calculate distance between the two coordinates
      double distance = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        destinationLatitude,
        destinationLongitude,
      );

      // Convert distance to kilometers
      double distanceInKm = distance / 1000;

      // Update the UI with the calculated distance
      setState(() {
        this.distanceInKm = distanceInKm;
      });
    } catch (e) {
      print("Error: $e");
    }
  }
}
