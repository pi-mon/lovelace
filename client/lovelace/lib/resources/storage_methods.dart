import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:lovelace/models/message.dart';
import 'package:lovelace/models/token_item.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async { 
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future getData(String route) {
  await 
}

class StorageMethods {
  final _secureStorage = const FlutterSecureStorage();
  // TODO: Get user email from server side to use as key for local storage of each user
  static const _keyToken = "token";
  static const _keyMessage = "message";

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> writeToken(String token) async {
    debugPrint("Writing new data to secure_storage");
    await _secureStorage.write(
        key: _keyToken, value: token, aOptions: _getAndroidOptions());
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

  Future<List<TokenItem>> readAllTokens() async {
    debugPrint("Reading all secured data");
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<TokenItem> list =
        allData.entries.map((e) => TokenItem(e.key, value: e.value)).toList();
    debugPrint('${list.length}'); // testing
    debugPrint(list.toString()); // testing
    return list;
  }

  Future writeMessages(List<Message> messages) async {
    debugPrint('Writing text messages into secure_storage');
    debugPrint('written message:$messages');
    String json = jsonEncode(messages.map((i) => i.toJson()).toList())
        .toString();
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
}
