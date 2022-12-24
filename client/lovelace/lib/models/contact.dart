import 'package:lovelace/models/user.dart';

class Contact {
  final User user;
  String lastMessage;
  String lastTime;
  
  Contact({required this.user, required this.lastMessage, required this.lastTime});
}