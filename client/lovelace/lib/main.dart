import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/screens/landing/guest_landing_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  bool? _jailbroken;
  bool? _developerMode;
  final bool isLoggedIn;
  final _userPages = const ResponsiveLayout(
    mobileScreenLayout: MobileScreenLayout(),
    webScreenLayout: WebScreenLayout());
  MyApp({Key? key, required this.isLoggedIn}) : super(key: key);  

  @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  // Future<void> initPlatformState() async {
  //   bool _jailbroken;
  //   bool _developerMode;

  //   try {
  //     _jailbroken = await FlutterJailbreakDetection.jailbroken;
  //     _developerMode = await FlutterJailbreakDetection.developerMode;
  //   } 
  //   on PlatformException {
  //     _jailbroken = true;
  //     _developerMode = true;
  //   }

  //   // If the widget was removed from the tree whike the asynchronous platform message was in flight,
  //   // we want to discard the reply rather than call setState to update our non-existent appearance
  
  // }


  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Lovelace',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        scaffoldBackgroundColor: whiteColor,
        primaryColor: primaryColor,
      ),
      home: isLoggedIn ? _userPages : const GuestLandingScreen()
    );
  }
}
