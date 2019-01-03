import 'package:flutter/material.dart';
import 'package:donors/login/Signupmaster.dart';
import 'package:donors/login/login.dart';
import 'package:donors/login/loginMaster.dart';
import 'package:donors/login/signup.dart';
import 'package:donors/login/logout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpMaster(),
      routes: {
        "/signup": (_) => Signup(),
        "/signupMaster": (_) => SignUpMaster(),
        "/login": (_) => Login(),
        "/loginMaster": (_) => LoginMaster(),
        "/home": (_) => Home(),
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donor"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
