import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Check extends StatefulWidget {
  @override
  CheckState createState() {
    return new CheckState();
  }
}

class CheckState extends State<Check> {
  TextEditingController controller, controller2;

  String contactNo = "", contactNoClient = "";

  @override
  void dispose() {
    controller?.dispose();
    controller2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              "YOUR CONTACT INFO:",
              style: TextStyle(fontWeight: FontWeight.bold),
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
            Text(
              "Clients contact no",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                  controller: controller2,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  decoration: InputDecoration(
                    labelText: "Contact no of client",
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
                    contactNoClient = s;
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: contactNo.length == 10 && contactNoClient.length == 10
                  ? () {
                      FirebaseAuth.instance.currentUser().then((u) {
                        u != null
                            ? Firestore.instance.collection('/requests').add({
                                "DONOR No": contactNoClient,
                                "RECIVER No": contactNo,
                                "RECIVER UID": u.uid,
                                "RECIVER EMAIL": u.email,
                              }).then((q) => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (_) => MainPage())))
                            : Firestore.instance.collection('/requests').add({
                                "DONOR No": contactNoClient,
                                "RECIVER No": contactNo
                              }).then((q) => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (_) => MainPage())));
                      });
                    }
                  : null,
              color: Colors.blueAccent,
              child: Text(
                "SUBMIT",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Note: THIS IS FOR SECURITY REASONS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
