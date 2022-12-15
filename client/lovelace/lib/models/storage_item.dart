// defines the model/stateto store data in a key-value pair
class StorageItem {
  StorageItem(this.key, {required this.value});

  final String key;
  final String value;
}