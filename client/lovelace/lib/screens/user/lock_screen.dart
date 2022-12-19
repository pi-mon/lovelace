import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/utils/colors.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});
  final _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ConstrainedBox(
              constraints: const BoxConstraints.expand(), child: _userPages),
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                            onPressed: () {
                              debugPrint('Attempting to unlock app');
                              // TODO: NEED TO INCLUDE MFA FUNCTION
                              AppLock.of(context)!.didUnlock(); // use this line to unlock the app
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => _userPages));
                            },
                            child: const Text('UNLOCK')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text('CANCEL'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
