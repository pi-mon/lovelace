import 'dart:convert';
import 'package:webcrypto/webcrypto.dart';

Future<JsonWebKeyPair> generateKeys() async { // GENERATE PUBLIC PRIVATE KEY PAIR FOR USER
  final keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);
  final publicKeyJwk = await keyPair.publicKey.exportJsonWebKey();
  final privateKeyJwk = await keyPair.privateKey.exportJsonWebKey();

  return JsonWebKeyPair(
      privateKey: json.encode(privateKeyJwk),
      publicKey: json.encode(publicKeyJwk));
}

class JsonWebKeyPair {
  final String publicKey;
  final String privateKey;

  const JsonWebKeyPair({required this.publicKey, required this.privateKey});
}

// SendersJwk -> sender.privateKey
// ReceiverJwk -> receiver.publicKey
Future<List<int>> deriveKey(String senderJwk, String receiverJwk) async { // GENERATE MESSAGE ENCRYPTION KEY
  // Sender's key
  final senderPrivateKey = json.decode(senderJwk);
  final senderEcdhKey = await EcdhPrivateKey.importJsonWebKey(
    senderPrivateKey,
    EllipticCurve.p256,
  );

  // Receiver's key
  final receiverPublicKey = json.decode(receiverJwk);
  final receiverEcdhKey = await EcdhPublicKey.importJsonWebKey(
    receiverPublicKey,
    EllipticCurve.p256,
  );

  // Generating CryptoKey
  final secretKey = await senderEcdhKey.deriveBits(256, receiverEcdhKey);
  return secretKey;
}