import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lovelace/models/message.dart';

class UserDetails {
  final String email;
  final String birthday;
  final String location;
  final Uint8List displayPic;
  final Uint8List cardPic;
  final String gender;
  List<Message> messages;
  
  UserDetails(
      {required this.email,
      required this.birthday,
      required this.location,
      required this.gender,
      required this.displayPic,
      required this.cardPic,
      required this.messages});

  UserDetails.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        birthday = json['birthday'],
        location = json['location'],
        gender = json['gender'],
        displayPic = json['displayPic'],
        cardPic = json['cardPic'],
        messages = json['messages'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'birthday': birthday,
        'location': location,
        'gender': gender,
        'displayPic': displayPic,
        'cardPic': cardPic,
        'messages': messages
      };
  

  @override
  String toString() =>
      'UserDetails{email: $email, birthday: $birthday, location: $location, gender: $gender, displayPic: $displayPic, messages: $messages}';
}
