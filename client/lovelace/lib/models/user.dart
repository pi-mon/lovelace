import 'dart:convert';
import 'dart:ui';

class User {
  final String email;
  final String password;
  final String displayName;
  final int otp;
  final String otpExpiry;

  User(
      {required this.email,
      required this.password,
      this.displayName = "",
      this.otp = -1,
      this.otpExpiry = ""});

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'],
        displayName = json['displayName'],
        otp = json['otp'],
        otpExpiry = json['otpExpiry'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'displayName': displayName,
        'otp': otp,
        'otpExpiry': otpExpiry,
      };
}

class UserDetails {
  final String email;
  final int age;
  final String location;
  final String profilePic;
  final String cardPic;
  // List chatMessages = List.empty(growable: true);

  UserDetails({
    required this.email,
    required this.age,
    required this.location,
    required this.profilePic,
    required this.cardPic,
  });

  UserDetails.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        age = json['age'],
        location = json['location'],
        profilePic = json['profilePic'],
        cardPic = json['cardPic'];
        // chatMessages = json['chatMessages'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'age': age,
        'location': location,
        'profilePic': profilePic,
        'cardPic': cardPic,
        // 'chatMessages': chatMessages
      };
  
  // Map<String, dynamic> toMap(UserDetails model) => <String, dynamic> {
  //   'email': model.email,
  //   'age': model.age,
  //   'location': model.location,
  //   'profilePic': model.profilePic,
  //   'cardPic': model.cardPic,
  //   'chatMessages': model.chatMessages
  // };

  // String serialize(UserDetails model) => jsonEncode(<String, dynamic> {
  //   'email': model.email,
  //   'age': model.age,
  //   'location': model.location,
  //   'profilePic': model.profilePic,
  //   'cardPic': model.cardPic,
  //   'chatMessages': model.chatMessages
  // });

  // UserDetails deserialize(String json) => UserDetails.fromJson(jsonDecode(json));
}
