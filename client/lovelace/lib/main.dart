import 'package:flutter/material.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/screens/login_screen.dart';
import 'package:lovelace/screens/register_email_screen.dart';
import 'package:lovelace/screens/register_password_screen.dart';
import 'package:lovelace/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: const RegisterPasswordScreen(),
      // home: const LoginScreen(),
    );
  }
}
