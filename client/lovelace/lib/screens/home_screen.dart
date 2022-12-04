import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is the Home Page!',
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.none
        ),
      ),    
    );
  }
}