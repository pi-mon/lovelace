import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Account(),
  ));
}

class Account extends StatelessWidget {
  const Account({super.key});

  @override // overrides the build function defined in the class's ancestor
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(    
            children: <Widget>[
              Image.asset('assets/images/logo-square.png', height: 50.0, width: 50.0),
              const Expanded(
                child: SizedBox.shrink(),
              ),
              Image.asset('assets/images/user.png', height: 50.0, width: 50.0)
            ],
          ),
        )
      ),

      body: Column(   
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,                
        children: <Widget>[    
          const SizedBox(height: 50.0),                
          Center(                      
            child: Row(   
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,           
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset('assets/images/user.png', height: 100.0, width: 100.0)
                ),
                Column(
                  children: <Widget>[
                    const Text('Name', style: TextStyle(fontSize: 20.0)),
                    const SizedBox(height: 5.0),
                    Row(                      
                      children: const <Widget>[
                        Icon(Icons.location_city),
                        Text('Singapore', style: TextStyle(fontSize: 15.0))
                      ],
                    )
                  ],
                )
              ],            
            )
          ),
          const SizedBox(height: 55.0),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(    
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,           
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {}, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                    child:                    
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.app_registration),
                            SizedBox(width: 10.0),
                            Text('Preferences', style: TextStyle(fontSize: 25.0)),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {}, 
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                      child: 
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.settings),
                            SizedBox(width: 10.0),
                            Text('Settings', style: TextStyle(fontSize: 25.0)),
                          ],
                        )
                      )
                  )
                ],              
              ),
            )
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