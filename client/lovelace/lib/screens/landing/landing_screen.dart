import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/images/landing_user.jpeg',
                          height: 525,
                          width: 350,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 525,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color.fromRGBO(26, 26, 26, .2),
                            ],
                            begin: FractionalOffset(0, 0),
                            end: FractionalOffset(0, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, bottom: 26),
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Shin",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "18 • Sembawang",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
