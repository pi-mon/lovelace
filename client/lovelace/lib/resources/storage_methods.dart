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

// class StorageMethods {
//   EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences(mode: AESMode.cbc);

//   Future<void> write(String value) async {
//     debugPrint('Writing data to encrypted shared preferences');
//     encryptedSharedPreferences.setString('token', value).then((bool success) {
//       if (success) {
//         debugPrint('write operation success');
//       }
//       debugPrint('Write operation failed');
//     });
//   }

//   Future<String?> read() async {
//     debugPrint('reading data from encrypted shared preferences');
//     encryptedSharedPreferences.getString('token').then((String value) {
//       debugPrint(value);
//     });
//   }

//   Future<void> delete() async {
//     encryptedSharedPreferences.remove('token').then((bool success) {
//       if (success) {
//         debugPrint('Data removed');
//       }
//       debugPrint('Error removing data');
//     });
//     encryptedSharedPreferences.reload();
//   }

//   Future<void> deleteAll() async {
//     encryptedSharedPreferences.clear().then((bool success) {
//       if (success) {
//         debugPrint('All data removed!');
//       }
//       debugPrint('Error removing all data!');
//     });
//     encryptedSharedPreferences.reload();
//   }
// }