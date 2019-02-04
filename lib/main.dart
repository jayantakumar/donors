import 'package:donors/infopage/gold.dart';
import 'package:flutter/material.dart';
import 'package:donors/login/Signupmaster.dart';
import 'package:donors/login/login.dart';
import 'package:donors/login/loginMaster.dart';
import 'package:donors/login/signup.dart';
import 'package:donors/login/logout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //FireBase messaging initialised

  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    _messaging.getToken().then((s) => print(s));
    _messaging.requestNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Courier",
        textTheme: TextTheme(
          title: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      home: SignUpMaster(),
      routes: {
        "/signup": (_) => Signup(),
        "/signupMaster": (_) => SignUpMaster(),
        "/login": (_) => Login(),
        "/loginMaster": (_) => LoginMaster(),
      },
    );
  }
}
