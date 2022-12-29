import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:lovelace/models/message.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:path_provider/path_provider.dart';

class StorageMethods {
  final _secureStorage = const FlutterSecureStorage();
  // TODO: Get user email from server side to use as key for local storage of each user
  static const _keyMessage = "message";
  static const _keyDisplayName = "display_name";
  static const _keyAge = "age";
  static const _keyLocation = "location";
  static const _keyEmail = "email";

  // AndroidOptions _getAndroidOptions() => const AndroidOptions(
  //       encryptedSharedPreferences: true,
  //     );

  // TODO: CHECK IF JSON OBJECT OF USER DISPLAYNAME EXISTS

  Future<bool> write(String key, dynamic value) async {
    await _secureStorage.write(key: key, value: value);
    debugPrint('$key written to secure_storage');
    return true;
  }

  Future<dynamic> read(String key) async {
    dynamic value = await _secureStorage.read(key: key);
    debugPrint('$key read from secure_storage');
    return value;
  }

  Future<List<StorageItem>> readAll() async {
    Map<String, String> items = await _secureStorage.readAll();
    List<StorageItem> itemList = items.entries
        .map((e) => StorageItem(key: e.key, value: e.value))
        .toList();
    debugPrint('${items.length} items in secure_storage');
    for (StorageItem item in itemList) {
      debugPrint('"${item.key}" : "${item.value}"');
    }
    return itemList;
  }

  Future<bool> delete(String key) async {
    await _secureStorage.delete(key: key);
    debugPrint('$key deleted from secure_storage');
    return true;
  }

  Future<bool> deleteAll() async {
    await _secureStorage.deleteAll();
    debugPrint('All items deleted from secure_storage');
    return true;
  }

  Future writeMessages(List<Message> messages) async {
    debugPrint('Writing text messages into secure_storage');
    debugPrint('Written message:$messages');
    String json =
        jsonEncode(messages.map((i) => i.toJson()).toList()).toString();
    debugPrint(json);
    // TODO: Write chat messages to json file
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
