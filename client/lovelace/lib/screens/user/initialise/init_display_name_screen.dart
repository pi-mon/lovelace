import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/initialise/init_gender.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class InitDisplayNameScreen extends StatefulWidget {
  const InitDisplayNameScreen({super.key});

  @override
  State<InitDisplayNameScreen> createState() => _InitDisplayNameScreenState();
}

class _InitDisplayNameScreenState extends State<InitDisplayNameScreen> {
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _displayNameController.dispose();
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
                      'What is your name?',
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
                    TextFieldInput(
                      label: "Display Name",
                      hintText: "Enter your full name",
                      textInputType: TextInputType.text,
                      textEditingController: _displayNameController,
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
                          String displayName = _displayNameController.text;
                          bool displayNameIsValid = displayName.isNotEmpty;
                          if (!displayNameIsValid) {
                            String message = "Invalid ";
                            if (!displayNameIsValid) {
                              message += "display name";
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
                                builder: (context) => InitGenderScreen(
                                      displayName: _displayNameController.text,
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
