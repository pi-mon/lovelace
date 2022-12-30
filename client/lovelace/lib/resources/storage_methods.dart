import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:lovelace/models/message.dart';
import 'package:lovelace/models/token_item.dart';
import 'package:lovelace/models/user_detail.dart';

class StorageMethods {
  final _secureStorage = const FlutterSecureStorage();
  static const _keyToken = "token";
  static const _keyMessage = "message";
  static const _keyDisplayName = "display_name";
  static const _keyAge = "age";
  static const _keyLocation = "location";
  static const _keyEmail = "email";
  static const _keyUser = "user";

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  // // TODO: Get user display name from server side to use as storage key
  // Future getUserData() async {}

  // FUNCTIONS TO SET & GET USER JSON OBJECTS
  Future<void> setUserObject(UserDetails user) async {
    debugPrint('Creating new user object');
    await _secureStorage.write(key: _keyUser, value: user.toJson().toString());
    debugPrint('New user object created');
  }

  // Future<UserDetails> getUserObject() async {
  //   // ignore: await_only_futures
  //   UserDetails user = UserDetails.fromJson(await _secureStorage.read(key: _keyUser) ?? '{}');
  //   debugPrint('user object: $user');
  //   return user;
  // }


  // STORAGE METHODS FOR JWT TOKEN
  Future<void> writeToken(TokenItem tokenItem) async {
    debugPrint("Writing new data to secure_storage");    
    await _secureStorage.write(
        key: _keyToken,
        value: tokenItem.toString(),
        aOptions: _getAndroidOptions());
    debugPrint('Data written to secure_storage');
  }

  Future<String?> readToken() async {
    debugPrint("Reading data from secure_storage");
    var readData = await Future.sync(() =>
        _secureStorage.read(key: _keyToken, aOptions: _getAndroidOptions()));
    return readData;
  }

  Future<void> deleteToken() async {
    debugPrint("Deleting data in secure_storage");
    await _secureStorage.delete(key: _keyToken, aOptions: _getAndroidOptions());
  }

  Future<void> deleteAllData() async {
    debugPrint('Deleting all data in seucre_storage');
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<List<TokenItem>> readAllData() async {
    debugPrint("Reading all secured data");
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<TokenItem> list = allData.entries
        .map((e) => TokenItem(key: e.key, value: e.value))
        .toList();
    debugPrint('${list.length}'); // testing
    debugPrint(list.toString()); // testing
    return list;
  }

  Future writeMessages(List<Message> messages) async {
    debugPrint('Writing text messages into secure_storage');
    debugPrint('Written message:$messages');
    String json =
        jsonEncode(messages.map((i) => i.toJson()).toList()).toString();
    debugPrint(json);
    await _secureStorage.write(key: _keyMessage, value: json);
  }

  Future readMessages() async {
    debugPrint('Reading text messages from secure_storage');
    final String? value = await _secureStorage.read(key: _keyMessage);
    debugPrint('value: $value'); // String
    dynamic map = jsonDecode(value!);
    debugPrint('map: $map');
    debugPrint(map[0]["text"]);
    return map;
    // ignore: unnecessary_null_comparison
    // return value == null ? null : List<Message>.from(messageList);
  }

  // READ/WRITE DISPLAYNAME
  Future setDisplayName(String displayName) async =>
      await _secureStorage.write(key: _keyDisplayName, value: displayName);
  Future<String?> getDisplayName() async =>
      _secureStorage.read(key: _keyDisplayName);

  // READ/WRITE AGE
  Future setAge(int age) async =>
      await _secureStorage.write(key: _keyAge, value: age.toString());
  Future<String?> getAge() async => await _secureStorage.read(key: _keyAge);

  // READ/WRITE LOCATION
  Future setLocation(String location) async =>
      await _secureStorage.write(key: _keyLocation, value: location);
  Future<String?> getLocation() async =>
      await _secureStorage.read(key: _keyLocation);

  // READ/WRITE EMAIL
  Future setEmail(String email) async =>
      await _secureStorage.write(key: _keyEmail, value: email);
  Future<String?> getEmail() async => await _secureStorage.read(key: _keyEmail);
}
