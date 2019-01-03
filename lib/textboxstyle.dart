import 'package:flutter/material.dart';

InputDecoration inputDec(String label, AsyncSnapshot snapshot) {
  return InputDecoration(
    errorText: snapshot == null ? "Error" : snapshot.error,
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
