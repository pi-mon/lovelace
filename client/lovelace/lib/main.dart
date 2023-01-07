import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/screens/main/landing_screen.dart';
import 'package:lovelace/screens/user/initialise/init_birthday_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : content = preferences.getCustomValue('content',
            defaultValue: 0,
            adapter: JsonAdapter(serializer: (value) => value));

  final Preference<dynamic> content;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final StorageMethods storageMethods = StorageMethods();
  final bool isLoggedIn =
      json.decode(await storageMethods.read('isLoggedIn') ?? 'false');
  final bool isFTL = json.decode(await storageMethods.read('isFTL') ?? 'false');

  // * Enable communication through HTTPS
  ByteData data = await PlatformAssetBundle().load('assets/ca/cert.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  // * Set the device orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp(isLoggedIn: isLoggedIn, isFTL: isFTL)));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool isFTL;
  final ResponsiveLayout _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());
  const MyApp(
      {Key? key, required this.isLoggedIn, required this.isFTL, Object? data})
      : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ScreenCaptureEvent screenCaptureEvent = ScreenCaptureEvent();
  // final bool _isJailbroken = true;
  double blurr = 20;
  double opacity = 0.6;
  StreamSubscription<bool>? subLock;

  @override
  void initState() {
    screenCaptureEvent.watch();
    screenCaptureEvent.preventAndroidScreenShot(true);
    WidgetsBinding.instance.addObserver(this);
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    screenShotRecord();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    if (state == AppLifecycleState.detached) return;

    if (state == AppLifecycleState.inactive) {
      debugPrint('App in background - $state');
    } else {
      debugPrint('App in foreground - $state');
    }
  }

  Future<void> screenShotRecord() async {
    bool isSecureMode = false;
    setState(() {
      isSecureMode = !isSecureMode;
    });
    print('secure mode: $isSecureMode');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
      fontFamily: 'Quicksand',
      scaffoldBackgroundColor: whiteColor,
      primaryColor: primaryColor,
    );
    Widget home;
    if (!widget.isLoggedIn) {
      // TODO: Check if user object exists in local storage
      home = const LandingScreen();
    } else if (widget.isFTL) {
      home = const InitBirthayScreen();
    } else {
      home = widget._userPages;
    }
    MaterialApp materialApp = MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Lovelace',
        theme: themeData,
        home: home);
    return materialApp;
  }
}
