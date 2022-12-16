import 'dart:ui';

class User {
  final int age;
  final String username;
  final String email;
  final String password;
  final String location;
  final Image profilepic;

  User(this.profilepic, {required this.age, required this.username, required this.location, required this.email, required this.password});

  static List<User> generateUsers() {
    return [
    ];
  }
}
