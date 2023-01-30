import 'package:flutter/material.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/screens/user/login/login_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class RegisterPinScreen extends StatefulWidget {
  const RegisterPinScreen({super.key});

  @override
  State<RegisterPinScreen> createState() => _RegisterPinScreenState();
}

class _RegisterPinScreenState extends State<RegisterPinScreen> {
  _RegisterPinScreenState();
  bool _isLoading = false;
  StorageMethods storageMethods = StorageMethods();
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
                                  'Register',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 20),
                                ))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create a PIN',
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
                      label: "PIN",
                      hintText: "6 characters minimum",
                      textInputType: TextInputType.text,
                      textEditingController: _pinController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const Text(
                      '*Please remember this PIN!',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

                          const String pinRegex =
                              r"^(?=\S{8,20}$)(?=.*?\d)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^A-Za-z\s0-9])";
                          final String pin = _pinController.text;

                          final bool pinValid = RegExp(pinRegex).hasMatch(pin);

                          if (!pinValid) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text('PIN does not meet the requirements'),
                              backgroundColor: errorColor,
                            ));
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text(
                                      "PIN Requirements:\n\t- Minimum 6 letters\n\t- Maximum 20 letters\n\t- At least 1 number\n\t- At least 1 lowercase alphabet\n\t- At least 1 uppercase alphabet\n\t- At least 1 special character"),
                                );
                              },
                            );
                            return;
                          }
                          // * Should store pin temporarily in SS for validation when logging in later.
                          // * Can delete pin from SS after using it to encrypt email & password.
                          setState(() {
                            _isLoading = false;
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
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
