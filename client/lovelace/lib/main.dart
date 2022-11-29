import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo-square2.png', fit: BoxFit.contain),
        backgroundColor: Colors.purpleAccent[700],
      ),
      // body: // start creating the page content here
    )
  ));
}