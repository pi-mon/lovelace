import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/widgets/session.dart';

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
        print(outputJson);
        
        if (outputJson['response'] != "User details has not been created yet") {
          isSuccess = true;
          message = "Read successful";
          debugPrint(output);
        } else {
          message = outputJson['response'];
        }
      } catch (e) {
        message = "An error occurred";
      }
    } catch (e) {
      output = e.toString();
    }
    debugPrint(output, wrapWidth: 1024);

    return [output, message, isSuccess];
  }

  Future<List> update({
    required String birthday,
    required String location,
    required Uint8List profilePic,
    required Uint8List displayPic,
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    try {
      UserDetails userDetails = UserDetails(
        email: await storageMethods.read("email"),
        birthday: DateTime.parse(birthday),
        location: location,        
        displayPic: displayPic,
        cardPic: displayPic,
        messages: [],
      );
      output = await session.post('/account/profile/update', userDetails);
      try {
        dynamic outputJson = jsonDecode(output);

        if (outputJson['response'] != "User details has not been created yet") {
          isSuccess = true;
          message = "Read successful";
          debugPrint(output);
        } else {
          message = outputJson['response'];
        }
      } catch (e) {
        message = "An error occurred";
      }
    } catch (e) {
      output = e.toString();
    }
    debugPrint(output, wrapWidth: 1024);

    return [output, message, isSuccess];
  }
}
