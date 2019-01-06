import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

class Search extends StatefulWidget {
  Search(this.bloodGroup);
  final String bloodGroup;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var queryResult = [];
  @override
  void initState() {
    queryResult = [];
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

  initSearch() async {
    var q = await SearchService().search(widget.bloodGroup, await getLoc());
    for (int i = 0; i < q.documents.length; ++i) {
      setState(() {
        queryResult.add(q.documents[i].data);
      });
    }
    queryResult != null ? await print(queryResult) : print("not found");
  }

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
      body: ListView.builder(
        itemBuilder: (_, index) => ListTile(
              title: Text(
                queryResult[index]["name"],
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: CircleAvatar(
                radius: 20,
                child: Text(
                  queryResult[index]["name"][0].toString().toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.white),
                ),
                backgroundColor: Colors.black,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          shape: Border.all(color: Colors.black, width: 4.0),
                          title: Text("Details"),
                          content: Text(
                            "Phone:" + queryResult[index]["phoneno"].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Clipboard.setData(new ClipboardData(
                                    text: queryResult[index]["phoneno"]
                                        .toString()));
                                key.currentState.showSnackBar(new SnackBar(
                                  content: new Text("Copied to Clipboard"),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Copy",
                                  textScaleFactor: 1.2,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ));
              },
              contentPadding: EdgeInsets.all(20),
            ),
        itemCount: queryResult.length,
      ),
    );
  }
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
