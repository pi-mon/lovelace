import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

class SecureToken {
  // TODO: Send AES key to server side for secure storage

  String aesEncryption(plaintext) {
    final key = encrypt.Key.fromSecureRandom(32);
    debugPrint('\nAES encryption key: ${key.base64}');
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    debugPrint('\nEncrpted JWT Token: ${encrypted.base64}');
    debugPrint('\nDecrypted JWT Token: $decrypted');
    return encrypted.base64;
  }
}
