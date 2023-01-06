import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/utils/global_variables.dart';

class InitCompleteScreen extends StatefulWidget {
  final String birthday;
  final String location;
  final File? profilePic;
  final File? displayPic;
  final String gender;

  const InitCompleteScreen(
      {super.key,
      required this.birthday,
      required this.location,
      required this.profilePic,
      required this.displayPic, required this.gender});

  @override
  State<InitCompleteScreen> createState() =>
      _InitDisplayPicScreenState(birthday, location, profilePic, displayPic, gender);
}

class _InitDisplayPicScreenState extends State<InitCompleteScreen> {
  _InitDisplayPicScreenState(
      this.birthday, this.location, this.profilePic, this.displayPic, this.gender);
  final String birthday;
  final String gender;
  final String location;
  final File? profilePic;
  final File? displayPic;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: primaryColor,
                          ),
                        ),
                        const Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(right: 32.0),
                                child: Text(
                                  'First Time Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 20),
                                ))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You\'re all set!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    // const SizedBox(height: 16),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    const Icon(Icons.check_rounded,
                        size: 250, color: primaryColor),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => userPages));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor: primaryColor,
                        ),
                        child: const Icon(
                          Icons.home,
                          color: Colors.white,
                        )),
                  ]))),
    );
  }
}