import 'package:flutter/material.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/screens/authentication/login_screen.dart';
import 'package:lovelace/screens/landing/guest_landing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Lovelace',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        scaffoldBackgroundColor: whiteColor,
        primaryColor: primaryColor,
      ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      // home: const GuestLandingScreen(),
      home: const LoginScreen() ,    
    );
  }
}

// setVisitedFlag() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance(); // return value from the future 
//   preferences.setBool("alreadyVisited", true); // set the alreadyVisited flag value to true after user visits the page
// }

// getVisitedFlag() async { // get the instance of the shared_preference
//   SharedPreferences preferences = await SharedPreferences.getInstance(); // return value from the future 
//   bool alreadyVisited = preferences.getBool("alreadyVisited") ?? false;
// }

