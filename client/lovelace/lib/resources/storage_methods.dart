import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    // iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock)
  );

  static const _key = 'token';
  
  static Future setToken(String token) async {    
    debugPrint(token);
    await _storage.write(key: _key, value: token);
  }

  static Future<String?> getToken() async {
    debugPrint("Getting token from secure storage");
    await _storage.read(key: _key);
  }
}