import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lovelace/resources/encryption_methods.dart';
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
    print('$file');
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
    String jsonString = await file.readAsString(); // returns ciphertext as a base64 String
    // print(jsonString); // return the ciphertext as a String
    // print(jsonString.runtimeType); // returns String
    var plaintext = await encryptionDecryption.decryptAES(jsonString); // decrypt the ciphertext
    print(plaintext.runtimeType);
    print(plaintext);
    // Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    debugPrint('Data read from JSON file');
    // return jsonMap;
  }

  Future<void> writeJsonFile(List messages) async {
    final file = await _localFile;
    debugPrint('Writing data to JSON file');
    Map<String, dynamic> jsonMap = {"Messages": messages};
    String jsonString = jsonEncode(jsonMap); // jsonEncode the map
    var encrypted = await encryptionDecryption.encryptAES(jsonString); // returns a base64 String of the ciphertext
    print(encrypted); // print the base64 encoded String 
    await file.writeAsString(encrypted); // write the base64 String to the JSON file
    debugPrint('Data written to JSON file');
  }
}
