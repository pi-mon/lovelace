import 'package:encrypt/encrypt.dart';

class EncryptionDecryption {
  static final key = Key.fromSecureRandom(32); // in bytes
  static final iv  = IV.fromSecureRandom(16); // in bytes
  static final encrypter = Encrypter(AES(key));

  Future encryptAES(plainText) async  {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // print(encrypted.bytes);
    // print(encrypted.base16);
    // print(encrypted.base64);
    return encrypted.base64;
  }

  Future decryptAES(cipherText) async {
    final decrypted = encrypter.decrypt(cipherText, iv: iv);
    return decrypted;
  }
}
