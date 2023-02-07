// Model class for storing keys
class JsonWebKeyPair {
  const JsonWebKeyPair({
    required this.privateKey,
    required this.publicKey,
  });

  final String privateKey;
  final String publicKey;
}