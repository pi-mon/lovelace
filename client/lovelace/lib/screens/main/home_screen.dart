import 'package:flutter/material.dart';
import 'package:lovelace/widgets/cards_stack_widget.dart';
// import 'package:lovelace/widgets/cards_stack_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const CardsStackWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
