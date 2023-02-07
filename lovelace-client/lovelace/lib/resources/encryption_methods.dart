import 'package:encrypt/encrypt.dart';
import 'package:lovelace/resources/storage_methods.dart';

class EncryptionDecryption {
  StorageMethods storageMethods = StorageMethods();

  Future encryptAES(plainText) async {
    final key = Key.fromSecureRandom(32);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // print(key.base64); // returns value of key
    storageMethods.write(
        "key", key.base64); // store key in secure storage as base64 encoded String
    storageMethods.write("iv", iv.base64); // store iv in secure storage as base64 encoded String
    return encrypted.base64; // return the encrypted data as base64 encoded String
  }

  Future decryptAES(cipherText) async { // cipherText argument is in base64 encoded String because it is read from the JSON file
    final secretKey =
        await storageMethods.read("key"); // data read is in base64 String form
    final secretIV = await storageMethods.read("iv");
    // print(secretKey.runtimeType); // return Instance of Key
    final key = Key.fromBase64(secretKey); // Decode base64 and convert to Key data type
    final iv = IV.fromBase64(secretIV); // Decode base64 and convert to IV data type
    final encrypter = Encrypter(AES(key));
    final decrypted =
        encrypter.decrypt(Encrypted.fromBase64(cipherText), iv: iv); // Decode the base64 String and convert to Encrypted data type. Apply the IV and encrypter to Encrypted data type to get plaintext
    return decrypted;
  }
}
