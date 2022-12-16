import 'package:lovelace/models/user.dart';

class Contact {
  final User user;
  String lastMessage;
  String lastTime;
  
  Contact(this.user, this.lastMessage, this.lastTime);
}