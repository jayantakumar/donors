import 'package:donors/infopage/storeinfo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'blocs/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';

class HomePage extends StatefulWidget {
  HomePage(this.user);
  final FirebaseUser user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<Coordinates> getCoordinates(String s) async {
    if (s.length > 4) {
      var coords = await Geocoder.local.findAddressesFromQuery(s).then((list) {
        var first = list.first;
        print(first.coordinates);
        prefs.setString("Lat", first.coordinates.latitude.toString());
        prefs.setString("Long", first.coordinates.longitude.toString());
        return first.coordinates;
      }).catchError((e) => print(e));
    }
  }

  Future<Coordinates> getAddressCoordinates(String s) async {
    if (s.length > 10) {
      await Geocoder.local.findAddressesFromQuery(s).then((list) {
        var first = list.first;
        print(first.coordinates);
        prefs.setString("AddressLat", first.coordinates.latitude.toString());
        prefs.setString("AddressLong", first.coordinates.longitude.toString());
        return first.coordinates;
      }).catchError((e) => print(e));
    }
  }

  TextEditingController locationTextController = new TextEditingController();
  TextEditingController addressTextController = new TextEditingController();
  Bloc bloc = new Bloc();
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    initSharedPref().then((pref) => prefs = pref);
    super.initState();
  }

  Future<SharedPreferences> initSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  @override
  void dispose() {
    _controller.dispose();
    locationTextController.dispose();
    super.dispose();
  }

  SharedPreferences prefs;
  List<String> qaList = [
    "Never Before",
    "1 month ago",
    "2 month ago",
    "3 month ago",
    "More Than that"
  ];

  Map<String, int> mapy = {
    "Never Before": 0,
    "1 month ago": 1,
    "2 month ago": 2,
    "3 month ago": 3,
    "More Than that": 0
  };

  List<String> bloodList = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  String bloodGroup = "Blood Group";
  String answer = "Blood Donation Status";
  CupertinoPicker cp() => CupertinoPicker.builder(
      itemExtent: 40,
      useMagnifier: true,
      diameterRatio: 0.9,
      magnification: 1.2,
      onSelectedItemChanged: (int a) {
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
  CupertinoPicker qa() => CupertinoPicker.builder(
      itemExtent: 40,
      useMagnifier: true,
      diameterRatio: 0.9,
      magnification: 1.2,
      onSelectedItemChanged: (int a) {
        setState(() {
          answer = qaList[a];
        });
      },
      childCount: qaList.length,
      //magnification: 2.5,
      //diameterRatio: 5,
      //useMagnifier: true,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            qaList[index],
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            textScaleFactor: 1.5,
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black, width: 4))),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 20)),
        title: Text(
          'Register',
          textScaleFactor: 1.5,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: new Column(
            //mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              StreamBuilder(
                builder: (_, snapshot) => new TextField(
                      decoration: inputDecoration("Name", snapshot),
                      onChanged: (s) {
                        prefs.setString("Name", s);
                        bloc.nameChanged(s);
                      },
                    ),
                stream: bloc.name,
              ),
              SizedBox(
                height: 40,
              ),
              StreamBuilder(
                stream: bloc.age,
                builder: (_, snapshot) => new TextField(
                      onChanged: (s) {
                        prefs.setString("Age", s);
                        bloc.ageChanged(int.parse(s));
                      },
                      decoration: inputDecoration("Age", snapshot),
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                    ),
              ),
              SizedBox(
                height: 40,
              ),
              StreamBuilder(
                stream: bloc.weight,
                builder: (_, snapshot) => new TextField(
                      onChanged: (s) {
                        bloc.weightChanged(int.parse(s));
                        prefs.setString("Weight", s);
                      },
                      decoration: inputDecoration("Weight", snapshot),
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                    ),
              ),
              SizedBox(
                height: 40,
              ),
              StreamBuilder(
                stream: bloc.location,
                builder: (_, snapshot) => new TextField(
                      onChanged: (s) async {
                        bloc.locationChanged(s);
                        await getCoordinates(s);
                      },
                      controller: locationTextController,
                      decoration: inputDecoration("City", snapshot),
                    ),
              ),
              SizedBox(
                height: 40,
              ),
              new TextField(
                onChanged: (s) async {
                  await getAddressCoordinates(s);
                },
                controller: addressTextController,
                decoration: inputDecoration("Address", null),
              ),
              SizedBox(
                height: 40,
              ),
              StreamBuilder(
                stream: bloc.phoneNo,
                builder: (_, snapshot) => new TextField(
                      onChanged: (s) {
                        bloc.phoneChanged(int.parse(s));
                        prefs.setString("PhoneNo", s);
                      },
                      decoration: inputDecoration("Phone no", snapshot),
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                    ),
              ),
              SizedBox(
                height: 40,
              ),
              new FlatButton(
                  splashColor: Colors.red,
                  padding: EdgeInsets.all(10),
                  shape: Border.all(color: Colors.black, width: 4),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        answer == "Blood Donation Status"
                            ? answer
                            : "Ans: " + answer,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  onPressed: () => showModalBottomSheet(
                      builder: (_) => SizedBox(
                            height: MediaQuery.of(context).size.height / 2.5,
                            child: qa(),
                          ),
                      context: context)),
              SizedBox(
                height: 40,
              ),
              new FlatButton(
                  splashColor: Colors.red,
                  padding: EdgeInsets.all(10),
                  shape: Border.all(color: Colors.black, width: 4),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        bloodGroup,
                        textScaleFactor: 2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  onPressed: () => showModalBottomSheet(
                      builder: (_) => SizedBox(
                            height: MediaQuery.of(context).size.height / 2.5,
                            child: cp(),
                          ),
                      context: context)),
              SizedBox(
                height: 50,
              ),
              StreamBuilder(
                stream: bloc.canSubmit,
                builder: (_, snapshot) => FlatButton(
                      padding: EdgeInsets.all(10),
                      disabledColor: Colors.pink[200],
                      onPressed: bloodGroup != "Blood Group" &&
                              answer != "Blood Donation Status" &&
                              snapshot.hasData
                          ? () {
                              infoSaver(
                                prefs.get("Name"),
                                int.parse(prefs.get("Age")),
                                int.parse(prefs.get("Weight")),
                                int.parse(prefs.get("PhoneNo")),
                                bloodGroup,
                                mapy[answer],
                                context,
                                widget.user,
                                double.parse(prefs.get("Lat")),
                                double.parse(prefs.get("Long")),
                                double.parse(prefs.get("AddressLat")),
                                double.parse(prefs.get("AddressLong")),
                              );
                            }
                          : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Submit",
                            textScaleFactor: 1.5,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      color: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black, width: 4.0)),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration inputDecoration(String label, AsyncSnapshot snapshot) {
  return InputDecoration(
    errorText: snapshot == null ? null : snapshot.error,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.red, width: 4),
    ),
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
    hasFloatingPlaceholder: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 4),
      borderRadius: BorderRadius.circular(0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.black54, width: 4),
    ),
    labelText: label,
  );
}
