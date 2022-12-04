import 'package:flutter/material.dart';
import 'package:lovelace/screens/authentication/login_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class GuestLandingScreen extends StatefulWidget {
  const GuestLandingScreen({super.key});

  @override
  State<GuestLandingScreen> createState() => _GuestLandingScreenState();
}

class _GuestLandingScreenState extends State<GuestLandingScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

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
                    Image.asset('assets/images/logo.png',
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
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ]))),
    );
  }
}
