import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sms/sms.dart';

class Search extends StatefulWidget {
  Search(this.bloodGroup);
  final String bloodGroup;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var queryResult = [];
  LatLng init = LatLng(0, 0);
  bool load = false, isEmpty = true;
  @override
  void initState() {
    queryResult = [];
    getLoc().then((p) {
      setState(() {
        init = LatLng(p.latitude, p.longitude);
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: init, zoom: 10)));
      });
    });
    initSearch();
    super.initState();
  }

  Future<GeoPoint> getLoc() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    Coordinates point = Coordinates(position.latitude, position.longitude);
    List<Address> address =
        await Geocoder.local.findAddressesFromCoordinates(point);
    print(address.first.locality);
    List<Address> newAddress =
        await Geocoder.local.findAddressesFromQuery(address.first.locality);
    return GeoPoint(newAddress.first.coordinates.latitude,
        newAddress.first.coordinates.longitude);
  }

  QuerySnapshot q;
  initSearch() async {
    q = await SearchService().search(widget.bloodGroup, await getLoc());

    setState(() {
      load = true;
      isEmpty = q == null;
    });

    for (int i = 0; i < q.documents.length; ++i) {
      setState(() {
        queryResult.add(q.documents[i].data);
      });
    }

    queryResult != null ? print(queryResult) : print("not found");
  }

  GoogleMapController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (c) {
          setState(() {
            controller = c;

            getLoc().then((o) {
              Firestore.instance
                  .collection("data")
                  .where('bloodgroup', isEqualTo: widget.bloodGroup)
                  .where("Location", isEqualTo: o)
                  .where("interval", isEqualTo: 0)
                  .getDocuments()
                  .then((q) {
                for (int i = 0; i < q.documents.length; i++) {
                  GeoPoint p = q.documents[i].data["address"];
                  print(p);
                  controller.addMarker(MarkerOptions(
                    position: LatLng(p.latitude, p.longitude),
                    infoWindowText:
                        InfoWindowText("Name", q.documents[i].data["name"]),
                    consumeTapEvents: true,
                  ));
                }
              });
            });
          });
          controller.onMarkerTapped.add((Marker marker) async {
            await Firestore.instance
                .collection("data")
                .where("name", isEqualTo: marker.options.infoWindowText.snippet)
                //.where("address",
                //  isEqualTo: GeoPoint(marker.options.position.latitude,
                //    marker.options.position.longitude))
                .getDocuments()
                .then((query) {
              print(query);
              AlertDialog dialog = AlertDialog(
                title:
                    Text(marker.options.infoWindowText.snippet.toUpperCase()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Phone no: ${query.documents[0]["phoneno"]}\n",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "Blood Group: ${query.documents[0]["bloodgroup"]}\n",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "Age: ${query.documents[0]["age"]}\n",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        SmsSender sender = new SmsSender();
                        sender.sendSms(
                            new SmsMessage("9488418964", "Welcome to fluuter"));
                      })
                ],
              );
              showDialog(
                context: context,
                builder: (_) => dialog,
              );
            });
          });
        },
        options: GoogleMapOptions(
          myLocationEnabled: true,
          rotateGesturesEnabled: false,
          cameraPosition: CameraPosition(target: init),
        ),
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Results",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      key: key,
      body: Center(
        child: !load
            ? Card(
                margin: EdgeInsets.all(20),
                elevation: 0,
                color: Colors.white,
                child: SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2,
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      new CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Colors.pink,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      new Text(
                        "Loading",
                        textScaleFactor: 2.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            : (isEmpty
                ? Center(
                    child: Text(
                    "No Results Found",
                    textAlign: TextAlign.center,
                    textScaleFactor: 3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
                : ListView.builder(
                    itemBuilder: (_, index) => queryResult.isEmpty
                        ? Center(
                            child: Text(
                            "No Results Found",
                            textAlign: TextAlign.center,
                            textScaleFactor: 3,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                        : ListTile(
                            title: Text(
                              queryResult[index]["name"],
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: CircleAvatar(
                              radius: 20,
                              child: Text(
                                queryResult[index]["name"][0]
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        shape: Border.all(
                                            color: Colors.black, width: 4.0),
                                        title: Text("Details"),
                                        content: Text(
                                          "Phone:" +
                                              queryResult[index]["phoneno"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Clipboard.setData(
                                                  new ClipboardData(
                                                      text: queryResult[index]
                                                              ["phoneno"]
                                                          .toString()));
                                              key.currentState
                                                  .showSnackBar(new SnackBar(
                                                content: new Text(
                                                    "Copied to Clipboard"),
                                              ));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Text(
                                                "Copy",
                                                textScaleFactor: 1.2,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                            contentPadding: EdgeInsets.all(20),
                          ),
                    itemCount: queryResult.length == 0 ? 1 : queryResult.length,
                  )),
      ),
    );
  }*/
}

class SearchService {
  search(String bloodType, GeoPoint point) async {
    return await Firestore.instance
        .collection("/data")
        .where('bloodgroup', isEqualTo: bloodType)
        .where("Location", isEqualTo: point)
        .where("interval", isEqualTo: 0)
        .getDocuments();
  }
}

Future<double> findDist(GeoPoint point) async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  return await Geolocator().distanceBetween(
      position.latitude, position.longitude, point.latitude, point.longitude);
}
