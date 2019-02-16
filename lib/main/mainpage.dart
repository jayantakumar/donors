import 'package:donors/main/recive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:donors/textboxstyle.dart';
import 'confirmation.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  List<String> bloodList = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];

  TextEditingController controller;
  final places =
      new GoogleMapsPlaces(apiKey: "AIzaSyAvZgT5ebFfr-eSSCFRi3D_qmRnQMALloU");
  String bloodGroup, hospitalName, contactNo;
  var currentuser;
  bool textBoxBool = false;
  CupertinoPicker cp(BuildContext context) => CupertinoPicker.builder(
      itemExtent: 40,
      useMagnifier: true,
      diameterRatio: 0.9,
      magnification: 1.2,
      onSelectedItemChanged: (int a) async {
        setState(() {
          bloodGroup = bloodList[a];
        });
      },
      childCount: 8,
      //magnification: 2.5,
      //diameterRatio: 5,
      //useMagnifier: true,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            bloodList[index],
            style: TextStyle(color: Colors.pink),
            textAlign: TextAlign.center,
            textScaleFactor: 2.5,
          ),
        );
      });

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((u) {
      setState(() {
        currentuser = u;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          "DONORS",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.1,
        ),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: currentuser != null
                  ? () async {
                      print(currentuser);
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context)
                          .pushReplacementNamed("/signupMaster");
                    }
                  : null),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  decoration: InputDecoration(
                    errorText: textBoxBool ? "Cannot find" : null,
                    labelText: "Hospital name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.black54, width: 4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Colors.red, width: 4),
                    ),
                  ),
                  onChanged: (s) {
                    hospitalName = s;

                    if (s.length < 5)
                      setState(() {
                        textBoxBool = true;
                      });
                    else
                      setState(() {
                        textBoxBool = false;
                      });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    decoration: InputDecoration(
                      labelText: "Contact no",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 4),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: Colors.black54, width: 4),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(color: Colors.red, width: 4),
                      ),
                    ),
                    onChanged: (s) {
                      contactNo = s;
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: FlatButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context, builder: (_) => cp(context));
                  },
                  color: Colors.blue,
                  child: Text(
                    "Select",
                    textScaleFactor: 2.0,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  splashColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: FlatButton(
                  padding: EdgeInsets.all(20),
                  onPressed: bloodGroup == null
                      ? null
                      : () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return Search(bloodGroup, hospitalName, contactNo);
                          }));
                        },
                  color: Colors.green,
                  disabledColor: Colors.green[100],
                  child: Text(
                    "Search",
                    textScaleFactor: 2.0,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  splashColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: FlatButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return Check();
                    }));
                  },
                  color: Colors.green,
                  disabledColor: Colors.green[100],
                  child: Center(
                    child: Text(
                      "confirm the user who accepted your offer",
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  splashColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
