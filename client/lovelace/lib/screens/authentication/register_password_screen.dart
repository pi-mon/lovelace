import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

import 'package:lovelace/models/user.dart';
import 'package:lovelace/screens/landing/landing_screen.dart';

class RegisterPasswordScreen extends StatefulWidget {
  final String email;
  const RegisterPasswordScreen({super.key, required this.email});

  @override
  State<RegisterPasswordScreen> createState() =>
      _RegisterPasswordScreenState(this.email);
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  _RegisterPasswordScreenState(this.email);
  final String email;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                  'Register',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 20),
                                ))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create a password',
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
                      isPass: true,
                      label: "Password",
                      hintText: "6 characters minimum",
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      isPass: true,
                      label: "Confirm Password",
                      hintText: "Re-enter your password",
                      textInputType: TextInputType.text,
                      textEditingController: _password2Controller,
                    ),
                    const SizedBox(height: 256),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {
                          String password = _passwordController.text;
                          var user = User(email, password);
                          String json = jsonEncode(user);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LandingScreen()),
                          );
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(json),
                              );
                            },
                          );
                        },

                        // onPressed: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const LandingScreen()),
                        //   );
                        // },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor: primaryColor,
                          // padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Sign Up",
                            style: TextStyle(
                                fontSize: 18,
                                color: whiteColor,
                                fontWeight: FontWeight.bold))),
                  ]))),
    );
  }
}
