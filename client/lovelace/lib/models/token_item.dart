// defines the model/stateto store data in a key-value pair
class TokenItem {
  const TokenItem({required this.key, required this.value});
  final String key;
  final String value;

  @override
  String toString() => '($key, $value)';
}