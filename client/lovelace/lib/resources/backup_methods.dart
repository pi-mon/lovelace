import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class BackupMethods {
  // read from local file
  Future get _localPath async {
    Directory? directory = await getExternalStorageDirectory();
    print(directory?.path);
    return directory?.path;
  }

  Future get _localFile async {
    final path = await _localPath;
    return File('$path/user-data.json');
  }

  Future<bool> _fileExists() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/user-data.json');
    return file.exists();
  }

  Future<Map<String, dynamic>> readJsonFile() async {
    dynamic response;
    final file = await _localFile;
    // Read the file
    debugPrint('Reading data from JSON file');
    // Check if file exists. Otherwise, return message
    final fileExists = await _fileExists();

    if (fileExists == true) {
      String jsonString = await file.readAsString();
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      print(jsonMap);
      debugPrint('Data read from JSON file');
      response = jsonMap;
    } else {
      // notify user file does not exist. Must back up first for file to be created
      response = "Sorry, the file does not exist!";
    }
    return response;
  }

  Future<void> writeJsonFile(
      String email, displayName, gender, birthday, location, messages) async {
    final file = await _localFile;
    debugPrint('Writing data to JSON file');
    Map<String, dynamic> jsonMap = {
      "Email": email,
      "Display Name": displayName,
      "Gender": gender,
      "Birthday": birthday,
      "Location": location,
      "Messages": messages
    };

    String jsonString = jsonEncode(jsonMap);
    await file.writeAsString(jsonString);
    debugPrint('Data written to JSON file');
  }
}
