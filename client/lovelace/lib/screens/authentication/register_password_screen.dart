import 'package:flutter/material.dart';
import 'package:lovelace/screens/authentication/login_screen.dart';
import 'package:lovelace/screens/authentication/register_email_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';
import 'package:lovelace/resources/auth_methods.dart';

class RegisterPasswordScreen extends StatefulWidget {
  final String email;
  const RegisterPasswordScreen({super.key, required this.email});

  @override
  State<RegisterPasswordScreen> createState() =>
      // ignore: no_logic_in_create_state
      _RegisterPasswordScreenState(email);
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
                          final String password = _passwordController.text;

                          List response = await AuthMethods()
                              .register(email: email, password: password);

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response[1]),
                            backgroundColor:
                                response[2] ? successColor : errorColor,
                          ));

                          if (response[2]) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterEmailScreen()),
                            );
                          }

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(response[0]),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor: primaryColor,
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
