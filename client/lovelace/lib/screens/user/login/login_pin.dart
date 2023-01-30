import 'package:flutter/material.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class LoginPinScreen extends StatefulWidget {
  final String pin;
  const LoginPinScreen({super.key, required this.pin});

  @override
  State<LoginPinScreen> createState() => _LoginPinScreenState(pin);
}

class _LoginPinScreenState extends State<LoginPinScreen> {
  _LoginPinScreenState(String pin);
  bool _isLoading = false;
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _pinController.dispose();
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
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 20),
                                ))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter your PIN',
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
                      label: "PIN",
                      hintText: "Enter your PIN",
                      textInputType: TextInputType.number,
                      textEditingController: _pinController,
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
                        if (_isLoading) return;
                        setState(() {
                          _isLoading = true;
                        });

                        String pin = _pinController.text;
                        // TODO: Need to decrypt encrypted email and password with
                        bool pinIsValid = pin.isNotEmpty && pin.length == 6;

                        if (!pinIsValid) {
                          String message = "Invalid PIN";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(message),
                            backgroundColor: errorColor,
                          ));
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }
                        setState(() {
                          _isLoading = false;
                        });

                        String message = 'Incorrect PIN!';
                        bool isSuccess = true;

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                          backgroundColor:
                              isSuccess ? successColor : errorColor,
                        ));

                        if (isSuccess) {
                          UserStateMethods().loginState(context, widget.pin);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        backgroundColor: primaryColor,
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                SizedBox(
                                    height: 14,
                                    width: 14,
                                    child: CircularProgressIndicator(
                                      color: whiteColor,
                                      strokeWidth: 4,
                                    )),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Verifying...',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ]))),
    );
  }
}
