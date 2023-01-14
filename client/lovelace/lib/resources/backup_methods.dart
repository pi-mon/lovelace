import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class BackupMethods {
  // get local file
  Future<File> get _localFile async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path; // get the local file
    File file = File('$path/sample.json');
    return file;
  }

  // read from local file
  Future<String> readFile() async {
    debugPrint('Reading data from local file');
    final file = await _localFile; // get the local file
    final contents = await file.readAsString(); // read file contents

    return contents;
  }

  // write to local file
  Future<File> writeFile(String data) async {
    debugPrint('Writing data to local file');
    final file = await _localFile; // get the local file
    print(file);
    print(data);
    return file.writeAsString(data); // write to the local file
  }
}
