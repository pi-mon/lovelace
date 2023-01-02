import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/register/register_verify_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';
import 'package:lovelace/resources/authenticate_methods.dart';

class RegisterPasswordScreen extends StatefulWidget {
  final String displayName;
  final String email;
  const RegisterPasswordScreen(
      {super.key, required this.displayName, required this.email});

  @override
  State<RegisterPasswordScreen> createState() =>
      _RegisterPasswordScreenState(displayName, email);
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  _RegisterPasswordScreenState(this.displayName, this.email);
  bool _isLoading = false;
  final String displayName;
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
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      isPass: true,
                      label: "Confirm Password",
                      hintText: "Re-enter your password",
                      textInputType: TextInputType.text,
                      textEditingController: _password2Controller,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 128),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          const String passwordRegex =
                              r"^(?=\S{8,20}$)(?=.*?\d)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^A-Za-z\s0-9])";
                          final String password = _passwordController.text;
                          final String password2 = _password2Controller.text;

                          final bool passwordMatch = password == password2;
                          final bool passwordValid =
                              RegExp(passwordRegex).hasMatch(password);

                          if (!passwordMatch) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Passwords do not match'),
                              backgroundColor: errorColor,
                            ));
                            return;
                          }

                          if (!passwordValid) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Password does not meet the requirements'),
                              backgroundColor: errorColor,
                            ));
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text(
                                      "Password Requirements:\n\t- Minimum 6 letters\n\t- Maximum 20 letters\n\t- At least 1 number\n\t- At least 1 lowercase alphabet\n\t- At least 1 uppercase alphabet\n\t- At least 1 special character"),
                                );
                              },
                            );
                            return;
                          }

                          List<dynamic> response = await AuthenticateMethods()
                              .register(
                                  email: email,
                                  password: password,
                                  displayName: displayName);

                          setState(() {
                            _isLoading = false;
                          });

                          String output = response[0];
                          String message = response[1];
                          bool isSuccess = response[2];

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(message),
                            backgroundColor:
                                isSuccess ? borderColor : errorColor,
                          ));

                          if (isSuccess) {
                            void goToRegisterVerifyScreen() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterVerifyScreen(
                                          displayName: displayName,
                                          email: email,
                                          password: password,
                                        )),
                              );
                            }
                            goToRegisterVerifyScreen();
                          } else if (message != "Please enter all the fields") {
                            Navigator.pop(context);
                          }

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(output),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor: primaryColor,
                        ),
                        child: !_isLoading
                            ? const Text("Sign Up",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold))
                            : const CircularProgressIndicator(
                                color: whiteColor,
                              )),
                  ]))),
    );
  }
}
