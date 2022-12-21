import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_root_jailbreak/flutter_root_jailbreak.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/screens/main/landing_screen.dart';
import 'package:lovelace/screens/user/lock_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_application/secure_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final isLoggedIn = preferences.getBool('isLoggedIn') ?? false;

  // * Set the device orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp(isLoggedIn: isLoggedIn)));

  ByteData data = await PlatformAssetBundle().load('assets/ca/cert.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(AppLock(
      builder: (arg) => MyApp(
            data: arg,
            key: const Key('MyApp'),
            isLoggedIn: isLoggedIn,
          ),
      lockScreen: const LockScreen(key: Key('LockScreen')),
      backgroundLockLatency: const Duration(seconds: 3),
      enabled: false));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());
  const MyApp({Key? key, required this.isLoggedIn, Object? data})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ScreenCaptureEvent screenCaptureEvent = ScreenCaptureEvent();
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  bool failedAuth = false;
  bool _isJailbroken = true;
  double blurr = 20;
  double opacity = 0.6;
  StreamSubscription<bool>? subLock;
  List<String> history = [];

  @override
  void initState() {
    screenCaptureEvent.watch();
    screenCaptureEvent.preventAndroidScreenShot(true);
    WidgetsBinding.instance.addObserver(this);
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    isRooted();
    screenShotRecord();
    super.initState();
  }

  @override
  void dispose() {
    subLock?.cancel();
    screenCaptureEvent.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) return;
    final inBackground = state == AppLifecycleState.paused;

    if (inBackground) {
      debugPrint('App in background - $state');
      // ignore: use_build_context_synchronously
      AppLock.of(context)!.showLockScreen();
    } else {
      debugPrint('App in foreground - $state');
    }
  }

  Future<void> isRooted() async {
    try {
      bool isJailBroken = Platform.isAndroid ? await FlutterRootJailbreak.isRooted : await FlutterRootJailbreak.isJailBroken;
      _isJailbroken = isJailBroken;
    } catch (e) {
      debugPrint('======ERROR: isRooted======');
    }

    setState(() {});
  }

  Future<void> screenShotRecord() async {
    bool isSecureMode = false;
    setState(() {isSecureMode = !isSecureMode;});
    // ignore: dead_code
    if (isSecureMode) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
    debugPrint('Secure Mode: $isSecureMode');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Lovelace',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          scaffoldBackgroundColor: whiteColor,
          primaryColor: primaryColor,
        ),
        // home: widget.isLoggedIn ? widget._userPages : const LandingScreen()),
        home: SecureApplication(
            onNeedUnlock: (secure) {
              debugPrint(
                  'Need to unlock using biometrics to authenticate user');
              return null;
            },
            nativeRemoveDelay: 500,
            onAuthenticationFailed: () async {
              setState(() {
                failedAuth = true;
              });
              debugPrint('Auth failed!');
            },
            onAuthenticationSucceed: () async {
              setState(() {
                failedAuth = false;
              });
              debugPrint('Auth succeeded!');
            },
            child: Builder(builder: (context) {
              return SecureGate(
                blurr: blurr,
                opacity: opacity,
                lockedBuilder: (context, secureApplicationController) => Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
                      child: const Text('Unlock'),
                      onPressed: () => secureApplicationController?.authSuccess(
                          unlock: true),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: const Text('Cancel'),
                        onPressed: () {
                          secureApplicationController?.authFailed(unlock: true);
                          SystemNavigator.pop(); // LEAVE THE APP
                        }),
                  ],
                )),
                child: Scaffold(
                  body: Builder(builder: (context) {
                    var valueNotifier = SecureApplicationProvider.of(context);
                    if (valueNotifier == null) {
                      throw Exception(
                          'Unable to find secure application context');
                    }
                    return widget.isLoggedIn
                        ? widget._userPages
                        : const LandingScreen();
                    // return ListView(
                    //   children: <Widget>[
                    //     ElevatedButton(
                    //       onPressed: () => valueNotifier.lock(),
                    //       child: const Text('manually lock'),
                    //     ),
                    //     ...history.map((h) => Text(h)).toList()
                    //   ],
                    // );
                  }),
                ),
              );
            })));
  }
}
