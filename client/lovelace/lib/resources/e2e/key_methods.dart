import 'dart:convert';
import 'package:lovelace/models/key_pair.dart';
import 'package:webcrypto/webcrypto.dart';

class KeyMethods {
  Future<JsonWebKeyPair> generateKeys() async {
    final keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);
    final publicKeyJwk = await keyPair.publicKey.exportJsonWebKey();
    final privateKeyJwk = await keyPair.privateKey.exportJsonWebKey();

    return JsonWebKeyPair(
      privateKey: json.encode(privateKeyJwk),
      publicKey: json.encode(publicKeyJwk),
    );
  }

  // SendersJwk -> sender.privateKey
  // ReceiverJwk -> receiver.publicKey
  Future<List<int>> deriveKey(String senderJwk, String receiverJwk) async {
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
    final derivedBits = await senderEcdhKey.deriveBits(256, receiverEcdhKey);
    return derivedBits;
  }
}