import 'package:flutter/foundation.dart';
import 'package:lovelace/models/message.dart';

class UserDetails {
  final String email;
  final String displayName;
  final String birthday;
  final String gender;
  final String location;
  final Uint8List displayPic;
  final Uint8List cardPic;
  List<Message> messages;

  UserDetails(
      {required this.email,
      required this.displayName,
      required this.birthday,
      required this.gender,
      required this.location,
      required this.displayPic,
      required this.cardPic,
      required this.messages});

  UserDetails.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        displayName = json['displayName'],
        birthday = json['birthday'],
        gender = json['gender'],
        location = json['location'],
        displayPic = json['displayPic'],
        cardPic = json['cardPic'],
        messages = json['messages'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'displayName': displayName,
        'birthday': birthday,
        'gender': gender,
        'location': location,
        'displayPic': displayPic,
        'cardPic': cardPic,
        'messages': messages
      };

  @override
  String toString() =>
      'UserDetails{email: $email, displayName: $displayName, birthday: $birthday, location: $location, gender: $gender, displayPic: $displayPic, messages: $messages}';
}
