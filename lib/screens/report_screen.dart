import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ReportScreen extends StatefulWidget {

  const ReportScreen({super.key});


  @override
  State<ReportScreen> createState() =>
      _ReportScreenState();

}



class _ReportScreenState extends State<ReportScreen> {


  final TextEditingController issueController =
      TextEditingController();



  bool loading = false;
String selectedLevel = "Low";



  Future<void> submitReport() async {


    setState(() {
      loading = true;
    });



    Position position =
        await Geolocator.getCurrentPosition();




    await FirebaseFirestore.instance
        .collection("reports")
        .add({


      "issue":
      issueController.text.trim(),
"waterLevel": selectedLevel,

      "latitude":
      position.latitude,


      "longitude":
      position.longitude,


      "timestamp":
      FieldValue.serverTimestamp(),


    });




    setState(() {

      loading = false;

    });




    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        content:
        Text(
            "Water Issue Reported Successfully"
        ),

      ),

    );



    Navigator.pop(context);


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title:
        const Text(
            "Report Water Issue"
        ),

        backgroundColor:
        Colors.blue,

      ),




      body: Padding(

        padding:
        const EdgeInsets.all(16),



        child: Column(

          children: [



            TextField(


              controller:
              issueController,


              maxLines:
              5,



              decoration:
              const InputDecoration(


                border:
                OutlineInputBorder(),


                hintText:
                "Describe water problem...",


              ),

            ),




            const SizedBox(
              height:20,
            ),
DropdownButtonFormField<String>(
  value: selectedLevel,
  decoration: const InputDecoration(
    labelText: "Water Level",
    border: OutlineInputBorder(),
  ),
  items: const [
    DropdownMenuItem(
      value: "Low",
      child: Text("Low"),
    ),
    DropdownMenuItem(
      value: "Medium",
      child: Text("Medium"),
    ),
    DropdownMenuItem(
      value: "High",
      child: Text("High"),
    ),
  ],
  onChanged: (value) {
    setState(() {
      selectedLevel = value!;
    });
  },
),

const SizedBox(height: 20),




            SizedBox(


              width:
              double.infinity,



              child:
              ElevatedButton(


                onPressed:
                loading
                    ? null
                    : submitReport,



                child:
                loading

                    ?

                const CircularProgressIndicator()

                    :

                const Text(
                    "Submit Report"
                ),


              ),


            ),



          ],

        ),

      ),

    );


  }


}