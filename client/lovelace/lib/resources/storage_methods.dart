import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  final storage = const FlutterSecureStorage();

  final String _keyEmail = 'email';
  final String _keyPassword = 'password';

  Future setEmail(String email) async {
    await storage.write(key: _keyEmail, value: email);
  }

  Future<String?> getEmail() async {
    return await storage.read(key: _keyEmail);
  }

  Future setPassword(String password) async {
    await storage.write(key: _keyPassword, value: password);
  }

  Future<String?> getPassword() async {
    return await storage.read(key: _keyPassword);
  }
}

