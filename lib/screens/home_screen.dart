import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/location_service.dart';
import '../services/firestore_service.dart';
import '../models/report_model.dart';

import 'report_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  String locationText = "Getting location...";
  String address = "Getting address...";


  double latitude = 19.3002;
  double longitude = 72.8567;


  final MapController mapController = MapController();



  @override
  void initState() {
    super.initState();
    getLocation();
  }



  Future<void> getLocation() async {

    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();


    if (!serviceEnabled) {

      setState(() {
        locationText = "Please turn ON Location";
      });

      return;
    }



    LocationPermission permission =
        await Geolocator.checkPermission();



    if (permission == LocationPermission.denied) {

      permission =
          await Geolocator.requestPermission();

    }



    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {


      setState(() {
        locationText = "Location Permission Denied";
      });


      return;
    }



    Position position =
        await Geolocator.getCurrentPosition();



    List<Placemark> placemarks =
        await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );



    Placemark place = placemarks.first;



    setState(() {

      latitude = position.latitude;
      longitude = position.longitude;


      locationText =
          "Latitude : ${position.latitude}\nLongitude : ${position.longitude}";


      address =
          "${place.subLocality}, ${place.locality}, ${place.administrativeArea}";

    });



    mapController.move(
      LatLng(latitude, longitude),
      16,
    );

  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("JalAlert"),

        centerTitle: true,

        backgroundColor: Colors.blue,

      ),



      body: Column(

        children: [


          Container(

            padding: const EdgeInsets.all(12),

            width: double.infinity,

            color: Colors.blue.shade50,


            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [

                Text(
                  locationText,
                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),


                const SizedBox(
                  height: 5,
                ),


                Text(address),

              ],

            ),

          ),




          Expanded(

            child: FlutterMap(

              mapController:
                  mapController,


              options: MapOptions(

                initialCenter:
                    LatLng(
                      latitude,
                      longitude,
                    ),

                initialZoom: 14,

              ),



              children: [



                TileLayer(

                  urlTemplate:
                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",

                  userAgentPackageName:
                  "com.example.jalalert",

                ),




                StreamBuilder<QuerySnapshot>(

                  stream:
                  FirebaseFirestore.instance
                      .collection("reports")
                      .snapshots(),



                  builder:
                      (context, snapshot) {


                    if (!snapshot.hasData) {

                      return const MarkerLayer(
                        markers: [],
                      );

                    }



                    List<Marker> markers = [];



                    for (var doc in snapshot.data!.docs) {

  var data = doc.data() as Map<String, dynamic>;
  print(data);

  if (data["latitude"] != null &&
      data["longitude"] != null) {



                        markers.add(

                          Marker(

                            point: LatLng(

                              data["latitude"],

                              data["longitude"],

                            ),


                            width: 40,

                            height:40,


                            child: GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data["issue"] ?? "Water Issue"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
  "📍 ${data["address"] ?? "Address not available"}",
),
const SizedBox(height: 10),
Text(
  "💧 Water Level : ${data["waterLevel"]}",
),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  },
  child: Icon(
    Icons.water_drop,
    color: data["waterLevel"] == "High"
        ? Colors.red
        : data["waterLevel"] == "Medium"
            ? Colors.orange
            : Colors.blue,
    size: 40,
  ),
),
                          ),

                        );

                      }

                    }



                    return MarkerLayer(
                      markers: markers,
                    );

                  },

                ),





                MarkerLayer(
  markers: [
    Marker(
      point: LatLng(latitude, longitude),
      width: 45,
      height: 45,
      child: const Icon(
        Icons.my_location,
        color: Colors.blue,
        size: 35,
      ),
    ),
  ],
),

              ],
            ),
          ),

          Padding(

            padding:
            const EdgeInsets.all(12),


            child: SizedBox(

              width:
              double.infinity,


              child: ElevatedButton.icon(


                onPressed: () {


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:
                          (context) =>
                      const ReportScreen(),

                    ),

                  );


                },


                icon:
                const Icon(
                    Icons.report
                ),


                label:
                const Text(
                  "Report Water Issue",
                ),


              ),

            ),

          ),


        ],

      ),

    );

  }

}