import 'package:flutter/material.dart';
import 'package:lovelace/services/storage_service.dart';
import 'package:lovelace/utils/colors.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  // color: Colors.pink,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Expanded(
                            flex: 3,
                            child: Icon(Icons.person, size: 60,)
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Row(children: const <Widget>[
                                      Text('Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    ],                                  
                                  ),
                                  Row(children: const <Widget>[
                                      Icon(Icons.location_city),
                                      SizedBox(width: 10),
                                      Text('Singapore')
                                    ],
                                  )
                                ],
                              ),
                            )                            
                          )
                        ],
                      ),
                    ],
                  )
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  // color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor
                            ),
                            child: const Text('Logout', style: TextStyle(fontSize: 20))                      
                          ),
                          ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor
                            ),
                            child: const Text('Settings', style: TextStyle(fontSize: 20))
                          )
                        ],
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

