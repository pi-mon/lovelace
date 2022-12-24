import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

class SecureToken {
  String aesEncryption(plaintext) {
    final key = encrypt.Key.fromSecureRandom(32);
    debugPrint('AES key: ${key.base64}');
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return encrypted.base64;
  }
}
