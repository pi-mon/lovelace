import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockVerifyScreen extends StatefulWidget {
  const LockVerifyScreen({super.key});

  @override
  State<LockVerifyScreen> createState() => _LockVerifyScreenState();
}

class _LockVerifyScreenState extends State<LockVerifyScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();
  final _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());
  final TextEditingController _emailController = TextEditingController();
  String message = "";
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  StorageMethods storageMethods = StorageMethods();

  Future<dynamic> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Login Success!' : 'Login Failed!';
    setState(() {
      _authorized = message;
    });
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Stack(
              children: <Widget>[
                ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: _userPages),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.5)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Unlock App',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Flexible(child: SizedBox(height: 200)),
                              TextFieldInput(
                                label: "Email",
                                hintText: "Enter your Email",
                                textInputType: TextInputType.text,
                                textEditingController: _emailController,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  bool? isLoggedIn =
                                      sharedPreferences.getBool('isLoggedIn');

                                  if (isLoggedIn == null || !isLoggedIn) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Login once to enable biometrics"),
                                    ));
                                  } else {
                                    String message =
                                        await authenticateWithBiometrics();
                                    bool isSuccess =
                                        message == 'Login Success!';

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(message),
                                      backgroundColor:
                                          isSuccess ? successColor : errorColor,
                                    ));

                                    if (isSuccess) {
                                      UserStateMethods().loginState(context);
                                    }
                                  }
                                },
                                elevation: 1.0,
                                color: Colors.white,
                                padding: const EdgeInsets.all(15.0),
                                shape: const CircleBorder(),
                                child: const Icon(
                                  Icons.fingerprint_rounded,
                                  size: 50.0,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                onPressed: () async {
                                  String emailInput = _emailController.text;
                                  dynamic user =
                                      storageMethods.read("userDetails");
                                  dynamic storedEmail = jsonDecode(user)[
                                      "email"]; // expect to return as Encrypted data

                                  if (emailInput == storedEmail) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => _userPages));
                                  }
                                },
                                child: const Text(
                                  'UNLOCK',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                  onPressed: () async {
                                    SystemNavigator.pop();
                                  },
                                  child: const Text('CANCEL'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
