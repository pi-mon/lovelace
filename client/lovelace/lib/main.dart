import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/screens/landing/guest_landing_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE); // TODO: FIND OUT HOW TO TEST
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

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        home: widget.isLoggedIn ? widget._userPages : const GuestLandingScreen());
  }
}
