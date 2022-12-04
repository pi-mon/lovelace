import 'package:flutter/material.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout_screen.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lovelace',
      // theme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: mobileBackgroundColor,
      // ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(), 
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: MobileScreenLayout()
    );
  }
}

