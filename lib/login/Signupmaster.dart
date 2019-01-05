import 'package:donors/infopage/gold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'animatedwave.dart';
import 'authnavigator.dart';
//import 'blocs/bloc.dart';

class SignUpMaster extends StatelessWidget {
  //initial declaration of variables
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //google sign in handler to handle log in using google

  Future<FirebaseUser> googleSignInHandler() async {
    //google initialisers
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    //creating firebase

    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print("signed in " + user.displayName);

    return user;
  }

  //focus nodes to handle focusing of cursor

  //widget builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  color: Colors.red,
                  width: double.infinity,
                  height: 400,
                ),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    child: Wave(
                      size: Size(
                        MediaQuery.of(context).size.width,
                        100,
                      ),
                      xOffset: 400,
                      yOffset: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                    child: SafeArea(
                      child: SvgPicture.asset(
                        "assets/tales.svg",
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 250),
                    child: Text(
                      "SignUp",
                      textScaleFactor: 3.0,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 20, right: 25),
              child: Column(
                //mainAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  googleWidget(context),
                  SizedBox(
                    height: 30,
                  ),
                  emailWidget(context),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed('/loginMaster'),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Aldready with us?".toUpperCase(),
                              textScaleFactor: 1.1,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3.5,
                            ),
                            Center(
                              child: Text(
                                "Login".toUpperCase(),
                                textScaleFactor: 1.1,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //functions related to login , logout etc...

  //LOGIN with google

  void loginWithGoogle(BuildContext context) async {
    googleSignInHandler().then((FirebaseUser user) {
      print(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(user)),
      );
    }).catchError((e) => print(e));
  }

  InputDecoration inputDec(String label, AsyncSnapshot snapshot) {
    return InputDecoration(
      errorText: snapshot.error,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: Colors.red, width: 4),
      ),
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
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

  Widget googleWidget(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(color: Colors.black, width: 4.0),
        ),
        onPressed: () => loginWithGoogle(context),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            SvgPicture.asset(
              "assets/google.svg",
              height: 30.0,
              width: 30.0,
            ),
            SizedBox(
              width: 24,
            ),
            Text(
              "Sign up with google".toUpperCase(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget emailWidget(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(color: Colors.black, width: 4.0),
        ),
        onPressed: () => Navigator.of(context).pushReplacementNamed('/signup'),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            Icon(
              Icons.mail_outline,
              color: Colors.black,
              size: 30,
            ),
            SizedBox(
              width: 24,
            ),
            Text(
              "Sign up with Email".toUpperCase(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
