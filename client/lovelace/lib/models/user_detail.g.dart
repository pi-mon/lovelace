// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => UserDetails(
      email: json['email'] as String,
      age: json['age'] as int,
      location: json['location'] as String,
      profilePic: json['profilePic'] as String,
      cardPic: json['cardPic'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'email': instance.email,
      'age': instance.age,
      'location': instance.location,
      'profilePic': instance.profilePic,
      'cardPic': instance.cardPic,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };
