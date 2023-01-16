import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/initialise/init_location_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/date_field_input.dart';

class InitBirthayScreen extends StatefulWidget {
  final String displayName;
  final String gender;

  const InitBirthayScreen(
      {super.key, required this.displayName, required this.gender});

  @override
  State<InitBirthayScreen> createState() => _InitBirthayScreenState();
}

class _InitBirthayScreenState extends State<InitBirthayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _birthdayController.dispose();
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
                      'When is your birthday?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    DateFieldInput(
                      label: "Birthday",
                      hintText: "Enter your birthday",
                      textInputType: TextInputType.datetime,
                      textEditingController: _birthdayController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 128),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                        onPressed: () async {
                          String birthday = _birthdayController.text;

                          bool birthdayIsValid = birthday.isNotEmpty;

                          if (!birthdayIsValid) {
                            String message = "Invalid ";
                            if (!birthdayIsValid) {
                              message += "birthday";
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                              backgroundColor: errorColor,
                            ));
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InitLocationScreen(
                                      displayName: widget.displayName,
                                      gender: widget.gender,
                                      birthday: _birthdayController.text,
                                    )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor: primaryColor,
                        ),
                        child: const Text("Next",
                            style: TextStyle(
                                fontSize: 18,
                                color: whiteColor,
                                fontWeight: FontWeight.bold))),
                  ]))),
    );
  }
}
