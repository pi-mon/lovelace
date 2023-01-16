import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BackupMethods {
  // get local file
  Future<File> get _localFile async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path; // get the local file
    File file = File('$path/sample.json');

    if (!await file.exists()) {
      // create the file if it doesn't exist
      file = await file.create();
    }
    print(file.toString());
    return file;
  }

  // read from local file
  Future<String> readFile() async {
    try {
      final file = await _localFile; // get the local file
      final contents = await file.readAsString(); // read file contents

      return contents;
    } catch (e) {
      return ('$e');
    }
  }

  // write to local file
  Future<File> writeFile(String data) async {
    final file = await _localFile; // get the local file
    return file.writeAsString(data); // write to the local file
  }
}
