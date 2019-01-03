import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';

//LOGOUT

void logOut(FirebaseAuth auth, BuildContext context) {
  if (auth.currentUser() != null)
    auth.signOut().then((val) {
      auth.currentUser().then((FirebaseUser user) async => user = null);
      //Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/loginMaster');
    }).catchError((e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(e.toString()),
              ));
    });
}
