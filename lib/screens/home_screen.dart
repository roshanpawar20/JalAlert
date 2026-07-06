import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String locationText = "Getting location...";
String address = "Getting address...";
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is ON
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        locationText = "Please turn ON Location.";
      });
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        setState(() {
          locationText = "Location permission denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationText = "Permission permanently denied.";
      });
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
);

List<Placemark> placemarks = await placemarkFromCoordinates(
  position.latitude,
  position.longitude,
);

Placemark place = placemarks.first;

setState(() {
  locationText =
      "Latitude: ${position.latitude}\nLongitude: ${position.longitude}";

  address =
      "${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text("JalAlert"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 45,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Current Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    locationText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

Text(
  address,
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
),
                ],
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: getLocation,
              icon: const Icon(Icons.my_location),
              label: const Text("Refresh Location"),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.warning),
              label: const Text("Report Waterlogging"),
            ),
          ],
        ),
      ),
    );
  }
}