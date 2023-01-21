import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:lovelace/resources/e2e/encryption_methods.dart';
import 'package:path_provider/path_provider.dart';

class BackupMethods {
  EncryptionDecryption encryptionDecryption = EncryptionDecryption();
  Future get _localPath async {
    Directory? directory = await getExternalStorageDirectory();
    // print(directory?.path);
    return directory?.path;
  }

  Future get _localFile async {
    final path = await _localPath;
    final file = File('$path/lovelace.json');
    print('inside _localFile function\n$file');
    return file;
  }

  Future<bool> fileExists(String path) async {
    return File(path).exists();
  }

  Future<dynamic> readJsonFile() async {
    bool exists;
    Directory? directory = await getExternalStorageDirectory();
    final path = directory?.path;
    final file = File('$path/lovelace.json');
    exists = await fileExists('$path/lovelace.json');
    if (exists == false) {
      return exists;
    } 
    debugPrint('Reading data from JSON file');
    var ciphertext = file.readAsString(); // returns ciphertext
    // Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    // debugPrint('Data read from JSON file');
    // return jsonMap;
  }

  Future<void> writeJsonFile(List messages) async {
    final file = await _localFile;
    debugPrint('Writing data to JSON file');
    Map<String, dynamic> jsonMap = {"Messages": messages};
    String jsonString = jsonEncode(jsonMap);
    dynamic encrypted = await encryptionDecryption.encryptAES(jsonString);
    print(encrypted);
    await file.writeAsString(encrypted);
    debugPrint('Data written to JSON file');
  }
}
