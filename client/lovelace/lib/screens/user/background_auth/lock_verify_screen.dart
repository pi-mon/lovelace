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
  final TextEditingController _pinController = TextEditingController();
  String message = "";
  StorageMethods storageMethods = StorageMethods();

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
                                'Enter PIN',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Flexible(child: SizedBox(height: 200)),
                              TextFieldInput(
                                label: "PIN",
                                hintText: "Enter your PIN",
                                textInputType: TextInputType.text,
                                textEditingController: _pinController,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                onPressed: () async {
                                  String pin = _pinController.text;
                                  dynamic user= storageMethods.read("userDetails");
                                  dynamic storedEmail = jsonDecode(user)["email"]; // expect to return as Encrypted data

                                  // TODO: Generate secret key with pin input
                                  // TODO: Decrypt email ciphertext in SS with generated secret key
                                  // TODO: If can decrypt, unlock app. Else, display error message
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => _userPages));
                                  // final userObjectString =
                                  //     await storageMethods.read("userDetails");
                                  // final userEmail =
                                  //     jsonDecode(userObjectString)["email"];
                                  // if (email == userEmail) {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => _userPages));
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(SnackBar(
                                  //     content: Text("Welcome back $userEmail!"),
                                  //     backgroundColor: successColor,
                                  //   ));
                                  //   print('$userEmail resumed app session');
                                  // }
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
