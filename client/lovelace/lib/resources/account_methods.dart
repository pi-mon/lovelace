import 'dart:convert';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/session.dart';

StorageMethods storageMethods = StorageMethods();
Session session = Session();

class AccountMethods {
  Future<List> read() async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    try {
      output = await session.get('/account/profile');
      try {
        dynamic outputJson = jsonDecode(output);

        if (outputJson['read'] == true) {
          isSuccess = true;
          message = "Read successful";
        } else {
          message = outputJson['response'];
        }
      } catch (e) {
        message = "An error occurred";
      }
    } catch (e) {
      output = e.toString();
    }
    print(output);

    return [output, message, isSuccess];
  }

  Future<List> update({required UserDetails userDetails}) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;
    try {
      output = await session.post('/account/profile/update', userDetails);
      try {
        dynamic outputJson = jsonDecode(output);

        if (outputJson['update'] == true) {
          isSuccess = true;
          message = "Update successful";
        } else {
          message = outputJson['response'];
        }
      } catch (e) {
        message = "An error occurred";
      }
    } catch (e) {
      output = e.toString();
    }

    print(output);

    return [output, message, isSuccess];
  }
}
