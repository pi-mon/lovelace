import 'package:lovelace/screens/account_screen.dart';
import 'package:lovelace/screens/chat_screen.dart';
import 'package:lovelace/screens/landing/guest_landing_screen.dart';
import 'package:lovelace/screens/landing/home_screen.dart';
import 'package:lovelace/screens/test.dart';

const webScreenSize = 600;

final userScreens = [
  // * List of pages only logged in users will see
  const HomeScreen(),
  const ChatScreen(),
  const AccountScreen(token: '',),
];