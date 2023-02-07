import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/screens/user/login/login_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final StorageMethods storageMethods = StorageMethods();

  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  bool isJailBroken = false;
  bool canMockLocation = false;
  bool isRealDevice = true;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  bool isDevelopmentModeEnable = false;

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print('$e');
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
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

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<dynamic> _authenticateWithBiometrics() async {
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

  Future<void> initPlatformState() async {
    await LocationPermissions().requestPermissions();
    if (!mounted) return;
    try {
      isJailBroken = await SafeDevice.isJailBroken;
      canMockLocation = await SafeDevice.canMockLocation;
      isRealDevice = await SafeDevice.isRealDevice;
      isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      isSafeDevice = await SafeDevice.isSafeDevice;
      isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    } catch (error) {
      print(error);
    }
    print('isJailBroken: $isJailBroken\n'
        'canMockLocation: $canMockLocation\n'
        'isRealDevice: $isRealDevice\n'
        'isOnExternalStorage: $isOnExternalStorage\n'
        'isSafeDevice: $isSafeDevice\n'
        'isDevelopmentModeEnable: $isDevelopmentModeEnable\n');
    setState(() {
      isJailBroken = isJailBroken;
      canMockLocation = canMockLocation;
      isRealDevice = isRealDevice;
      isOnExternalStorage = isOnExternalStorage;
      isSafeDevice = isSafeDevice;
      isDevelopmentModeEnable = isDevelopmentModeEnable;
    });
  }

  Widget get _biometricButton {
    if (_supportState == _SupportState.supported) {
      return MaterialButton(
        onPressed: () async {
          // SharedPreferences sharedPreferences =
          //     await SharedPreferences.getInstance();
          // bool? isLoggedIn = sharedPreferences.getBool('isLoggedIn');
          final bool isLoggedIn =
              json.decode(await storageMethods.read('isLoggedIn') ?? 'false');
          print("isLoggedIn: $isLoggedIn");
          if (isLoggedIn == null || !isLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Login once to enable biometrics"),
            ));
          } else {
            String message = await _authenticateWithBiometrics();
            bool isSuccess = message == 'Login Success!';

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: isSuccess ? successColor : errorColor,
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
      );
    }
    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    // force isSafeDevice to true for now
    isSafeDevice = true;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: (() {
                if (_supportState == _SupportState.unknown) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                        Image.asset('assets/images/logo-dark.png',
                            height: 200.0, width: 200.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Sign In >",
                                style: TextStyle(
                                    color: primaryColor, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 128),
                        _biometricButton,
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                      ]);
                }
              }())),
          Positioned(
              bottom: 30.0,
              right: 30.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  fixedSize: const Size(50, 50),
                  backgroundColor: primaryColor,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        Map<String, String> supportMap = {
                          "Lost or forgot password":
                              "lovelace.dating+password@gmail.com",
                          "Technical assistance":
                              "lovelace.dating+technical@gmail.com",
                          "Billing inquiries":
                              "lovelace.dating+billing@gmail.com"
                        };
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (String title in supportMap.keys)
                              ListTile(
                                leading: IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: supportMap[title]));
                                  },
                                ),
                                title: Text(title),
                                subtitle: SelectableText(supportMap[title]!),
                              )
                          ],
                        );
                      });
                },
                child: const Icon(
                  Icons.question_mark,
                  color: whiteColor,
                ),
              )),
          !isSafeDevice
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Text(
                          "Your device is not safe to use this app",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      )),
    );
  }
}
