import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageMethods {
  final _secureStorage = const FlutterSecureStorage();

  Future<bool> write(String key, dynamic value) async {
    // if value is not string then convert it to string
    if (value is! String) {
      value = json.encode(value);
    }
    await _secureStorage.write(key: key, value: value);
    print('$key written to secure_storage');
    return true;
  }

  Future read<T>(String key) async {
    dynamic value = await _secureStorage.read(key: key);
    print('$key read from secure_storage');
    // print(value);
    return value;
  }

  Future<Map<String, dynamic>> readAllJson() async {
    Map<String, dynamic> data = await _secureStorage.readAll();
    return data;
  }

  Future<bool> delete(String key) async {
    await _secureStorage.delete(key: key);
    print('$key deleted from secure_storage');
    return true;
  }

  Future<bool> deleteAll() async {
    await _secureStorage.deleteAll();
    print('All items deleted from secure_storage');
    return true;
  }
}
