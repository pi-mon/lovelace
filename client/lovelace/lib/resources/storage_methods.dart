import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class StorageMethods {
  final _secureStorage = const FlutterSecureStorage();
  static const _keyDisplayName = "display_name";
  static const _keyAge = "age";
  static const _keyLocation = "location";
  static const _keyEmail = "email";

  Future<bool> write(String key, dynamic value) async {
    // if value is not string then convert it to string
    if (value is! String) {
      value = json.encode(value);
    }
    await _secureStorage.write(key: key, value: value);
    debugPrint('$key written to secure_storage');
    return true;
  }

  // Future<void> writeUserJson(String email, dynamic value) async { // accept the email to be used as key
  //   // write the object to local storage
  //   await _secureStorage.write(key: "key_$email", value: value);
  // }

  Future read<T>(String key) async {
    // "T" is a generic type parameter used to specify the variable type when the exact type is still unknown
    dynamic value = await _secureStorage.read(key: key);
    debugPrint('$key read from secure_storage');
    return value;
  }

  Future<Map<String, dynamic>> readAllJson() async {
    Map<String, dynamic> data = await _secureStorage.readAll();
    debugPrint('$data');
    return data;
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
