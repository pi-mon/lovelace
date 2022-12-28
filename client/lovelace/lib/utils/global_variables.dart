import 'package:lovelace/screens/chat/chat_screen.dart';
import 'package:lovelace/screens/user/account_screen.dart';
import 'package:lovelace/screens/main/home_screen.dart';
import 'package:flutter/foundation.dart';

const webScreenSize = 600;

final userScreens = [
  // * List of pages only logged in users will see
  const HomeScreen(),
  const ChatScreen(),
  const AccountScreen(),
];

String checkDevice() {
  String baseUrl = "10.0.2.2";
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    baseUrl == "127.0.0.1";
  }
  return "$baseUrl:3000";
}
