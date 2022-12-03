import 'package:flutter/material.dart';
import 'package:lovelace/app/home/home_page.dart';
import 'package:lovelace/core/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lovelace',
      debugShowCheckedModeBanner: false,
      home: NavigationPage()
    );
  }
}

