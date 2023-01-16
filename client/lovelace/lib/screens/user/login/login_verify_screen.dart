import 'package:flutter/material.dart';
import 'package:lovelace/resources/authenticate_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class LoginVerifyScreen extends StatefulWidget {
  final String email;
  final String password;
  const LoginVerifyScreen(
      {super.key, required this.email, required this.password});

  @override
  State<LoginVerifyScreen> createState() =>
      _LoginVerifyScreenState(email, password);
}

class _LoginVerifyScreenState extends State<LoginVerifyScreen> {
  _LoginVerifyScreenState(this.email, this.password);
  bool _isLoading = false;

  final String email;
  final String password;

  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  // void iniState() {
  //   super.initState();
  //   init();
  // }

  // Future init() async {
  //   final otp = await SecureStorage().getotp() ?? '';

  //   setState(() {
  //     this._otpController.text = otp;
  //   });
  // }

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
                                  'Verify your email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 20),
                                ))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Check your email for OTP',
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
                      label: "OTP",
                      hintText: "Enter your OTP",
                      textInputType: TextInputType.number,
                      textEditingController: _otpController,
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

                        String otp = _otpController.text;

                        bool otpIsValid = otp.isNotEmpty && otp.length == 6;

                        if (!otpIsValid) {
                          String message = "Invalid OTP";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(message),
                            backgroundColor: errorColor,
                          ));
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }
                        List<dynamic> response = await AuthenticateMethods()
                            .verify(
                                method: "login",
                                email: email,
                                password: password,
                                otp: int.parse(otp));

                        setState(() {
                          _isLoading = false;
                        });

                        // String output = response[0];
                        String message = response[1];
                        bool isSuccess = response[2];

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                          backgroundColor:
                              isSuccess ? successColor : errorColor,
                        ));

                        if (isSuccess) {
                          // ignore: use_build_context_synchronously
                          UserStateMethods().loginState(context);
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
