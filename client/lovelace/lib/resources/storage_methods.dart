import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:lovelace/models/storage_item.dart';

class StorageMethods {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> write(StorageItem newItem) async {
    debugPrint("Writing new data to secure_storage");
    await _secureStorage.write(
        key: newItem.key, value: newItem.value, aOptions: _getAndroidOptions());
    debugPrint('Data written to secure_storage');
  }

  Future<String?> read(String key) async {
    debugPrint("Reading data from secure_storage");
    var readData = await Future.sync(
        () => _secureStorage.read(key: key, aOptions: _getAndroidOptions()));
    return readData;
  }

  Future<void> delete(StorageItem item) async {
    debugPrint("Deleting data in secure_storage");
    await _secureStorage.delete(key: item.key, aOptions: _getAndroidOptions());
  }

  Future<List<StorageItem>> readAll() async {
    debugPrint("Reading all secured data");
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<StorageItem> list =
        allData.entries.map((e) => StorageItem(e.key, value: e.value)).toList();
    debugPrint('${list.length}'); // testing
    debugPrint(list.toString()); // testing
    return list;
  }

  Future<void> deleteAll() async {
    debugPrint("Deleting all secured data");
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }
}
