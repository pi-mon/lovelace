import 'package:flutter/material.dart';
import 'package:lovelace/widgets/display_card.dart';
import 'package:lovelace/widgets/cards_stack_widget.dart';

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
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: const [
                  CardsStackWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
