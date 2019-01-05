import 'package:donors/infopage/gold.dart';
import 'package:flutter/material.dart';
//import 'package:tale/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';

class AuthNavigator {
  Firestore f = Firestore.instance;

  storeUser(FirebaseUser user, context) async {
    f.settings(
      timestampsInSnapshotsEnabled: true,
    );
    await f.collection('/users').add({
      'email': user.email,
      'userid': user.uid,
      'pic_url': user.photoUrl
    }).then((val) async {
      // await Future.delayed(Duration(seconds: 1));
      //Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage(user)));
    });
  }
}
