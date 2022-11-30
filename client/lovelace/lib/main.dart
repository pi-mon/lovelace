import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Account(),
  ));
}

class Account extends StatelessWidget {
  @override // overrides the build function defined in the class's ancestor
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Row(                            
          children: <Widget>[
            Image.asset('assets/images/logo-square.png', height: 50.0, width: 50.0),
            const Expanded(
              child: SizedBox.shrink(),
            ),
            Image.asset('assets/images/user.png', height: 50.0, width: 50.0)
          ],
        )
      ),
      
      body: Column(   
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.cyan,
            child: Row(
            )
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.yellow,
            child: Text('hello')
          ),
        ]
      )
    );
  }
}

// class Account extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }