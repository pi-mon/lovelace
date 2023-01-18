import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class BackupMethods {
  // int counter = 1;
  // read from local file
  Future get _localPath async {
    Directory? directory = await getExternalStorageDirectory();
    // print(directory?.path);
    return directory?.path;
  }

  Future get _localFile async {
    // * Try to limit the number of backups user can make in a certain time
    final path = await _localPath;
    // final file = File('$path/lovelace_$counter.json');
    final file = File('$path/lovelace.json');
    print('inside _localFile function\n$file');
    // file.createSync();
    // counter++;
    return file;
  }

  Future<bool> fileExists(String path) async {
    return File(path).exists();
  }

  Future<dynamic> readJsonFile() async {
    // * Right now, the last file created is read.
    // * Should allow user to type in file name and choose which one to back up to
    bool exists;
    Directory? directory = await getExternalStorageDirectory();
    final path = directory?.path;
    // final file = File('$path/lovelace_${counter - 1}.json');
    final file = File('$path/lovelace.json');
    print('inside readJsonFile function\n$file');
    // exists = await fileExists('$path/lovelace_${counter - 1}.json');
    exists = await fileExists('$path/lovelace.json');
    // print(exists);
    if (exists == false) {
      return exists;
    } 
    debugPrint('Reading data from JSON file');
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    debugPrint('Data read from JSON file');
    return jsonMap;
  }

  Future<void> writeJsonFile(List messages) async {
    final file = await _localFile;
    debugPrint('Writing data to JSON file');
    Map<String, dynamic> jsonMap = {"Messages": messages};

    String jsonString = jsonEncode(jsonMap);
    await file.writeAsString(jsonString);
    debugPrint('Data written to JSON file');
  }
}
