import 'package:flutter/material.dart';
import 'package:lovelace/widgets/cards_stack_widget.dart';
import 'package:lovelace/widgets/display_card.dart';
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
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: const CardsStackWidget(),
                // child: const DisplayCard(
                //   image: "assets/images/landing-user.jpeg",
                //   name: 'John Doe',
                //   age: 21,
                //   location: 'London',
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
