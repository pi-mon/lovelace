import 'package:flutter/foundation.dart';
import 'package:lovelace/screens/user/account_screen.dart';
import 'package:lovelace/screens/room/chat_screen.dart';
import 'package:lovelace/screens/main/home_screen.dart';

const webScreenSize = 600;

final userScreens = [
  // * List of pages only logged in users will see
  const HomeScreen(),
  const ChatScreen(),
  const AccountScreen(),
];

String checkDevice() {
  String baseUrl = "127.0.0.1";
  if (defaultTargetPlatform == TargetPlatform.android) {
    baseUrl == "10.0.2.2";
  }
  return "$baseUrl:3000";
}
