import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:lovelace/models/message.dart';
// must be same name as this file (AKA user_detail)
// g stands for generated
part 'user_detail.g.dart';

@JsonSerializable(explicitToJson: true) // needed for nested classes
class UserDetails {
  final String email;
  final int age;
  final String location;
  final String profilePic;
  final String cardPic;
  List<Message> messages;

  UserDetails(
      {required this.email,
      required this.age,
      required this.location,
      required this.profilePic,
      required this.cardPic,
      required this.messages});
  
  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);

  // UserDetails.fromJson(Map<String, dynamic> json)
  //     : email = json['email'],
  //       age = json['age'],
  //       location = json['location'],
  //       profilePic = json['profilePic'],
  //       cardPic = json['cardPic'],
  //       messages = json['cardPic'];

  // static Map<String, dynamic> toMap(UserDetails userDetails) =>
  //     <String, dynamic>{
  //       'email': userDetails.email,
  //       'age': userDetails.age,
  //       'location': userDetails.location,
  //       'profilePic': userDetails.profilePic,
  //       'cardPic': userDetails.cardPic,
  //       'messages': userDetails.messages
  //     };

  // static String serialize(UserDetails userDetails) =>
  //     jsonEncode(UserDetails.toMap(userDetails));
  // static UserDetails deserialize(String json) =>
  //     UserDetails.fromJson(jsonDecode(json));

  @override
  String toString() => 'UserDetails{email: $email, age: $age, location: $location, profilePic: $profilePic, messages: $messages}';
}
