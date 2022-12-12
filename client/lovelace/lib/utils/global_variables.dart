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
