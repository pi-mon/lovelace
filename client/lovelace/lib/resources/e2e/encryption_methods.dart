import 'package:encrypt/encrypt.dart';
import 'package:lovelace/resources/storage_methods.dart';

class EncryptionDecryption {
  static final key = Key.fromSecureRandom(32);
  final iv = IV.fromSecureRandom(16);
  final encrypter = Encrypter(AES(key));
  StorageMethods storageMethods = StorageMethods();

  Future encryptAES(plainText) async  {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print(key.base64); // returns value of key
    storageMethods.write("key", key.base64); // store secret key in secure storage
    return encrypted.base64;
  }

  Future decryptAES(cipherText) async {
    final keyString =  await storageMethods.read("key"); // read the key from secure storage
    print(keyString.runtimeType);
    final encrypter = Encrypter(AES(keyString));
    // final decrypted = encrypter.decrypt(cipherText, iv: iv);
    // return decrypted;
  }
}
