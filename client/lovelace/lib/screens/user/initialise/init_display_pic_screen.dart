import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/screens/user/initialise/init_complete_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:lovelace/widgets/display_card.dart';

class InitDisplayPicScreen extends StatefulWidget {
  final String displayName;
  final String gender;
  final String birthday;
  final String location;
  final File profilePic;

  const InitDisplayPicScreen(
      {super.key,
      required this.displayName,
      required this.gender,
      required this.birthday,
      required this.location,
      required this.profilePic});

  @override
  State<InitDisplayPicScreen> createState() =>
      _InitDisplayPicScreenState(profilePic);
}

class _InitDisplayPicScreenState extends State<InitDisplayPicScreen> {
  final File profilePic;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final AccountMethods _accountMethods = AccountMethods();

  _InitDisplayPicScreenState(this.profilePic) {
    _image = profilePic;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime birthDate = DateTime.parse(widget.birthday);
    int age = AgeCalculator.dateDifference(
            fromDate: birthDate, toDate: DateTime.now())
        .years;

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
                      'What is your display picture?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 28),
                      child: GestureDetector(
                        onTap: () async {
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              // print("setstate done");
                              _image = File(image.path);
                            });
                          }
                        },
                        child: DisplayCard(
                            image: Image.file(_image!).image,
                            name: widget.displayName,
                            age: age,
                            location: widget.location),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      // padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            bool imageIsValid = _image != null;
                            if (!imageIsValid) {
                              String message = "Empty ";
                              if (!imageIsValid) {
                                message += "image";
                              }
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(message),
                                backgroundColor: errorColor,
                              ));
                              return;
                            }
                            // Uint8List profilePicData =
                            //     await widget.profilePic.readAsBytes();
                            // Uint8List displayPicData =
                            //     await _image!.readAsBytes();
                            UserDetails userDetails = UserDetails(
                              email: await StorageMethods().read("email") ?? "",
                              displayName: widget.displayName,
                              birthday: widget.birthday,
                              gender: widget.gender,
                              location: widget.location,
                              profilePic: widget.profilePic.path,
                              displayPic: _image!.path,
                            );
                            List response = await _accountMethods.update(
                                userDetails: userDetails);
                            bool isSuccess = response[2];
                            if (isSuccess) {
                              // String output = response[0];
                              StorageMethods().delete("isFTL");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const InitCompleteScreen()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: primaryColor,
                          ),
                          child: const Text("Submit",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ]))),
    );
  }
}
