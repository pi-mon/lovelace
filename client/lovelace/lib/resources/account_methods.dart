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
        dynamic outputJson = json.decode(output);

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
    String output = "";
    String message = "";
    bool isSuccess = false;
    // List<Map<String, String>> filesMap = [
    //   {"name": "profile_picture", "path": userDetails.profilePic},
    //   {"name": "display_picture", "path": userDetails.displayPic}
    // ];
    updateDetails(userDetails: userDetails).then((value) {
      output += value[0];
      message += value[1];
      isSuccess = isSuccess && value[2];
    });
    if (userDetails.profilePic != "") {
      updateFile(fileName: "profile_pic", filePath: userDetails.profilePic)
          .then((value) => {
                output += value[0],
                message += value[1],
                isSuccess = isSuccess && value[2],
              });
    }
    if (userDetails.displayPic != "") {
      updateFile(fileName: "display_pic", filePath: userDetails.displayPic)
          .then((value) => {
                output += value[0],
                message += value[1],
                isSuccess = isSuccess && value[2],
              });
    }
    return [output, message, isSuccess];
  }

  Future<List> updateDetails({required UserDetails userDetails}) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;
    try {
      output = await session.post(
        '/account/profile/update',
        userDetails,
      );
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

  Future<List> updateFile(
      {required String fileName, required String filePath}) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;
    try {
      output = await session.post(
        '/account/profile/update/$fileName',
        [fileName, filePath],
        isFilePath: true,
      );
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
