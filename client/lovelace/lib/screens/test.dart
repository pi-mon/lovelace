import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestPageState();
}

class _TestPageState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Test Page!'),
    );
  }
}