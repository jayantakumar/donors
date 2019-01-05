import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donors/main/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

infoSaver(
  String name,
  int age,
  int weight,
  int phoneNo,
  String bloodGroup,
  int interval,
  BuildContext context,
  FirebaseUser user,
  double lat,
  double long,
) async {
  Firestore firestore = Firestore.instance;
  firestore.settings(
    timestampsInSnapshotsEnabled: true,
  );
  await firestore.collection('/data').add({
    "name": name,
    "age": age,
    "weight": weight,
    "phoneno": phoneNo,
    "bloodgroup": bloodGroup,
    "interval": interval,
    "email": user.email,
    "uid": user.uid,
    "Location": GeoPoint(lat, long)
  }).then((v) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
  });
}
