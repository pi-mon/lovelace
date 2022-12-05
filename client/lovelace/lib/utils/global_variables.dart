import 'package:lovelace/screens/account_screen.dart';
import 'package:lovelace/screens/home_screen.dart';
import 'package:lovelace/screens/chat_screen.dart';
import 'package:lovelace/screens/landing/landing_screen.dart';

const webScreenSize = 600;

final screens = [
  // * This is a list of the different pages to navigate to in the app
  const LandingScreen(),
  const ChatScreen(),
  const AccountScreen(),
];
