import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/images/landing_user.jpeg',
                          height: 400,
                          width: 400 / 3 * 2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 400,
                      width: 400 / 3 * 2,
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
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.only(left: 42, bottom: 26),
                        child: Column(
                          children: const <Widget>[
                            Align(
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
                            Align(
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
