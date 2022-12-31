// defines the model/stateto store data in a key-value pair
class StorageItem {
  const StorageItem({required this.key, required this.value});
  final String key;
  final dynamic value;

  @override
  String toString() => '$key: {$value}';
}
