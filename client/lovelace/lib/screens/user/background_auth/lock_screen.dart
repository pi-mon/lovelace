import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();
  final _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String message = "";
  StorageMethods storageMethods = StorageMethods();

  // _SupportState _supportState = _SupportState.unknown;
  // bool? _canCheckBiometrics;
  // List<BiometricType>? _availableBiometrics;
  // String _authorized = 'Not Authorized';
  // bool _isAuthenticating = false;

  // @override
  // void initState() {
  //   super.initState();
  //   auth.isDeviceSupported().then(
  //         (bool isSupported) => setState(() => _supportState = isSupported
  //             ? _SupportState.supported
  //             : _SupportState.unsupported),
  //       );
  // }

  // Future<void> _checkBiometrics() async {
  //   late bool canCheckBiometrics;
  //   try {
  //     canCheckBiometrics = await auth.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     canCheckBiometrics = false;
  //     print('$e');
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(() {
  //     _canCheckBiometrics = canCheckBiometrics;
  //   });
  // }

  // Future<void> _getAvailableBiometrics() async {
  //   late List<BiometricType> availableBiometrics;
  //   try {
  //     availableBiometrics = await auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     availableBiometrics = <BiometricType>[];
  //     print('$e');
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(() {
  //     _availableBiometrics = availableBiometrics;
  //   });
  // }

  // Future<void> _authenticate() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason: 'Let OS determine authentication method',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //       ),
  //     );
  //     setState(() {
  //       _isAuthenticating = false;
  //     });
  //   } on PlatformException catch (e) {
  //     print('$e');
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Error - ${e.message}';
  //     });
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(
  //       () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  // }

  // Future<dynamic> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason:
  //           'Scan your fingerprint (or face or whatever) to authenticate',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //         biometricOnly: true,
  //       ),
  //     );
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Authenticating';
  //     });
  //   } on PlatformException catch (e) {
  //     print('$e');
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Error - ${e.message}';
  //     });
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   final String message = authenticated ? 'Authorized' : 'Not Authorized';
  //   setState(() {
  //     _authorized = message;
  //   });
  //   return message;
  // }

  // Future<void> _cancelAuthentication() async {
  //   await auth.stopAuthentication();
  //   setState(() => _isAuthenticating = false);
  // }

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
                              // MaterialButton(
                              //   onPressed: () async {
                              //     var message = _authenticateWithBiometrics();
                              //     if (await message == 'Authorized') {
                              //       Navigator.push(context,
                              //           MaterialPageRoute(builder: (context) {
                              //         return _userPages;
                              //       }));
                              //     }
                              //   },
                              //   elevation: 1.0,
                              //   color: whiteColor,
                              //   padding: const EdgeInsets.all(15.0),
                              //   shape: const CircleBorder(),
                              //   child: const Icon(
                              //     Icons.fingerprint_rounded,
                              //     size: 50.0,
                              //   ),
                              // ),
                              const Text(
                                'Enter email and password',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Flexible(child: SizedBox(height: 200)),
                              TextFieldInput(
                                label: "Email",
                                hintText: "Enter your email",
                                textInputType: TextInputType.emailAddress,
                                textEditingController: _emailController,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                onPressed: () async {
                                  String email = _emailController.text;
                                  final userObjectString =
                                      await storageMethods.read("userDetails");
                                  final userEmail =
                                      jsonDecode(userObjectString)["email"];
                                  if (email == userEmail) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => _userPages));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Welcome back $userEmail!"),
                                      backgroundColor: successColor,
                                    ));
                                    print('$userEmail resumed app session');
                                  } else {
                                    message = "Incorrect email address!";
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(message),
                                      backgroundColor: errorColor,
                                    ));
                                    print("Failed to resume app session");
                                  }
                                },
                                child: const Text(
                                  'UNLOCK',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
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
