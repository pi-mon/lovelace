import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BackupMethods {
  // read from local file
  // Future<String> readFile() async {
  //   debugPrint('Reading data from local file');
  //   final String response = await rootBundle
  //       .loadString('assets/sample.json'); // read data from json file
  //   final data = await jsonDecode(response); // read file contents
  //   return data;
  // }

  Future<File> writeStringToJsonFile(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');
    print(file);
    final map = {'data': data};
    return file.writeAsString(jsonEncode(map));
  }

  Future<String> readStringFromJsonFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');
    final jsonString = await file.readAsString();
    final jsonData = jsonDecode(jsonString);
    return jsonData['data'];
  }
}
