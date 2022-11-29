import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Row(                            
          children: <Widget>[
            Image.asset('assets/images/logo-square.png'),
            const Expanded(
              child: SizedBox.shrink(),
            ),
            Image.asset('assets/images/user.png')
          ],
        )
      ),

      // body: // start creating the page content here
    )
  ));
}