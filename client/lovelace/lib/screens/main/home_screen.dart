import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/screens/user/initialise/init_birthday_screen.dart';
import 'package:lovelace/widgets/display_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: DisplayCard(
                  image: File('assets/images/landing-user.jpeg'),
                  name: 'John Doe',
                  age: 21,
                  location: 'London',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
