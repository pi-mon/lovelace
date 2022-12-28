import 'package:flutter/foundation.dart';
import 'package:webcrypto/webcrypto.dart';

final Uint8List iv = Uint8List.fromList('Initialization Vector'.codeUnits);

class SecureMessageMethods {
  Future<String> encryptMessage(String message, List<int> deriveKey) async {
    // importing generated secretKey
    final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(deriveKey);

    // Convert message into bytes
    final messageBytes = Uint8List.fromList(message.codeUnits);

    // Encrypt the message
    final encryptedMessageBytes =
        await aesGcmSecretKey.encryptBytes(messageBytes, iv);

    // Convert encrypted message into String
    final encryptedMessage = String.fromCharCodes(encryptedMessageBytes);
    return encryptedMessage;
  }

  Future<String> decryptMessage(
    String encryptedMessage, List<int> deriveKey) async {
    // import the generated secret key
    final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(deriveKey);

    // Convert message into bytes
    final messageBytes = Uint8List.fromList(encryptedMessage.codeUnits);

    // Decrypt the message
    final decryptedMessageBytes =
        await aesGcmSecretKey.decryptBytes(messageBytes, iv);

    // Convert decrypted message into String
    final decryptedMessage = String.fromCharCodes(decryptedMessageBytes);
    return decryptedMessage;
  }

  // TODO: Send encrypted message to server side with signed digital sigature
  
}
