// defines the model/stateto store data in a key-value pair
class TokenItem {
  const TokenItem({required this.value});
  final String value;

  @override
  String toString() => '{$value}';
}