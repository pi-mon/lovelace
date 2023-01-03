import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/screens/user/initialise/init_complete_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:lovelace/widgets/display_card.dart';

class InitDisplayPicScreen extends StatefulWidget {
  final String birthday;
  final String location;
  final File? profilePic;

  const InitDisplayPicScreen(
      {super.key,
      required this.birthday,
      required this.location,
      required this.profilePic});

  @override
  State<InitDisplayPicScreen> createState() =>
      _InitDisplayPicScreenState(birthday, location, profilePic);
}

class _InitDisplayPicScreenState extends State<InitDisplayPicScreen> {
  _InitDisplayPicScreenState(this.birthday, this.location, this.profilePic);
  final String birthday;
  final String location;
  final File? profilePic;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final AccountMethods _accountMethods = AccountMethods();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime birthDate = DateTime.parse(birthday);
    int age = AgeCalculator.dateDifference(
            fromDate: birthDate, toDate: DateTime.now())
        .years;
    _image = profilePic;

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
                    // const SizedBox(height: 16),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 32),
                      child: GestureDetector(
                        onTap: () async {
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = File(image.path);
                            });
                          }
                        },
                        child: DisplayCard(
                            name: "Your name", age: age, location: location),
                        // Stack(
                        //   alignment: Alignment.bottomCenter,
                        //   children: <Widget>[
                        //     Container(
                        //       alignment: Alignment.center,
                        //       child: ClipRRect(
                        //           borderRadius: BorderRadius.circular(25),
                        //           child: Image.file(
                        //             _image!,
                        //             height: 400,
                        //             width: 400 / 3 * 2,
                        //             fit: BoxFit.cover,
                        //           )),
                        //     ),
                        //     Container(
                        //       height: 400,
                        //       width: 400 / 3 * 2,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(25),
                        //         gradient: const LinearGradient(
                        //             colors: [
                        //               Colors.transparent,
                        //               Color.fromRGBO(26, 26, 26, .2),
                        //             ],
                        //             begin: FractionalOffset(0, 0),
                        //             end: FractionalOffset(0, 1),
                        //             stops: [0.0, 1.0],
                        //             tileMode: TileMode.clamp),
                        //       ),
                        //     ),
                        //     Align(
                        //       alignment: Alignment.bottomCenter,
                        //       child: Container(
                        //         padding:
                        //             const EdgeInsets.only(left: 18, bottom: 24),
                        //         child: Column(
                        //           children: <Widget>[
                        //             const Align(
                        //               alignment: Alignment.centerLeft,
                        //               child: Text(
                        //                 "Your Name",
                        //                 overflow: TextOverflow.ellipsis,
                        //                 textAlign: TextAlign.left,
                        //                 style: TextStyle(
                        //                   color: whiteColor,
                        //                   fontSize: 32,
                        //                   fontWeight: FontWeight.w700,
                        //                 ),
                        //               ),
                        //             ),
                        //             Align(
                        //               alignment: Alignment.centerLeft,
                        //               child: Text(
                        //                 "$age • $location",
                        //                 overflow: TextOverflow.ellipsis,
                        //                 textAlign: TextAlign.left,
                        //                 style: const TextStyle(
                        //                   color: whiteColor,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w700,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          bool imageIsValid = _image != null;

                          if (!imageIsValid) {
                            String message = "Empty ";
                            if (!imageIsValid) {
                              message += "image";
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                              backgroundColor: errorColor,
                            ));
                            return;
                          }
                          Uint8List profilePicData =
                              await profilePic!.readAsBytes();
                          Uint8List displayPicData =
                              await _image!.readAsBytes();

                          _accountMethods.update(
                              birthday: birthday,
                              location: location,
                              profilePic: profilePicData,
                              displayPic: displayPicData);

                          void goToInitCompleteScreen() {
                            Navigator.push(context, 
                                MaterialPageRoute(
                                    builder: (context) => InitCompleteScreen(
                                        birthday: birthday,
                                        location: location,
                                        profilePic: profilePic,
                                        displayPic: _image)));
                          }
                          goToInitCompleteScreen();
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
                  ]))),
    );
  }
}
