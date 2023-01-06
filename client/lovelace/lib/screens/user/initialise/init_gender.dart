import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/initialise/init_location_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/date_field_input.dart';

class InitGenderScreen extends StatefulWidget {
  final String birthday;
  const InitGenderScreen({super.key, required this.birthday});

  @override
  State<InitGenderScreen> createState() => _InitGenderScreenState();
}

class _InitGenderScreenState extends State<InitGenderScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  String dropDownValue = 'Male';

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
                              // Navigator.pop(context);
                            },
                            child: Container()
                            // const Icon(
                            //   Icons.arrow_back_ios,
                            //   color: primaryColor,
                            // ),
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
                      'What is your gender?',
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
                    DropdownButton<String>(
                      value: dropDownValue,
                      items: <String>['Male, Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
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

                          bool genderIsValid = birthday.isNotEmpty;

                          if (!genderIsValid) {
                            String message = "Invalid ";
                            if (!genderIsValid) {
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
                                      gender: dropDownValue,
                                      birthday: birthday,
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
