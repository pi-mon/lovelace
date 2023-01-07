import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/initialise/init_location_screen.dart';
import 'package:lovelace/utils/colors.dart';

class InitGenderScreen extends StatefulWidget {
  final String birthday;
  const InitGenderScreen({super.key, required this.birthday});

  @override
  State<InitGenderScreen> createState() => _InitGenderScreenState();
}

class _InitGenderScreenState extends State<InitGenderScreen> {
  // final TextEditingController _genderController = TextEditingController();
  List<String> dropdownValues = ['Male', 'Female'];
  String dropdownValue = 'Male';

  @override
  void dispose() {
    super.dispose();
    // _genderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String dropdownValue = dropdownValues[0];
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
                      value: dropdownValue,
                      items: dropdownValues.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
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
                          // String gender = _genderController.text;
                          String gender = dropdownValue;

                          bool genderIsValid = gender.isNotEmpty;

                          if (!genderIsValid) {
                            String message = "Invalid ";
                            if (!genderIsValid) {
                              message += "gender";
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
                                      birthday: widget.birthday,
                                      gender: gender,
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
