import 'package:flutter/material.dart';
import 'package:lovelace/screens/authentication/login_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/main.dart';

class GuestLandingScreen extends StatefulWidget {
  const GuestLandingScreen({super.key});

  @override
  State<GuestLandingScreen> createState() => _GuestLandingScreenState();
}

class _GuestLandingScreenState extends State<GuestLandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Image.asset('assets/images/logo-dark.png',
                        height: 200.0, width: 200.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginScreen();
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Sign In >",
                            style: TextStyle(color: primaryColor, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 128),
                    MaterialButton(
                      onPressed: () {},
                      elevation: 1.0,
                      color: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.fingerprint_rounded,
                        size: 50.0,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ]))),
    );
  }
}
