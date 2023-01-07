import 'dart:convert';
import 'package:flutter/foundation.dart';
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
        print(outputJson);

        if (outputJson['read'] == true) {
          // User Details already exist
          isSuccess = true;
          message = "Read successful";
        } else {
          // User Details don't exist. Direct user to init pages and store object locally
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

  // Future<List> update({
  //   required String birthday,
  //   required String gender,
  //   required String location,
  //   required Uint8List profilePic,
  //   required Uint8List displayPic,
  // }) async {
  //   String output;
  //   String message = "An error occurred";
  //   bool isSuccess = false;

  //   try {
  //     // DateFormat dateFormat = DateFormat('MMMM yyyy');
  //     UserDetails userDetails = UserDetails(
  //         email: await storageMethods.read("email"),
  //         displayName: displayName,
  //         gender: gender,
  //         birthday: birthday,
  //         location: location,
  //         displayPic: displayPic,
  //         cardPic: displayPic,
  //         messages: []);
  //     print("ERROR HERE!!");
  //     output = await session.post(
  //         '/account/profile/update',
  //         userDetails
  //             .toString()); // will get conversion error if not in String format
  //     print("AFTER THE ERROR");
  //     try {
  //       dynamic outputJson = jsonDecode(output);

  //       if (outputJson['response'] != "User details has not been created yet") {
  //         isSuccess = true;
  //         message = "Read successful";
  //         print(output);
  //       } else {
  //         message = outputJson['response'];
  //       }
  //     } catch (e) {
  //       message = "An error occurred";
  //     }
  //   } catch (e) {
  //     output = e.toString();
  //   }
  //   print(output);

  //   return [output, message, isSuccess];
  // }
}
