import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:lovelace/models/user.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/session.dart';

var logger = Logger();

String updatedData = "";
StorageMethods storageMethods = StorageMethods();
Session session = Session();

class AuthenticateMethods {
  Future<List> register({
    required String email,
    required String password,
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email: email, password: password);
      try {
        output = await session.post('/account/create', user);

        try {
          dynamic outputJson = jsonDecode(output);

          if (outputJson['creation'] == true) {
            isSuccess = true;
            message = "Enter OTP to verify your account";
            print(output);
          } else {
            message = outputJson['response'];
          }
        } catch (e) {
          message = "An error occurred";
        }
      } catch (e) {
        output = e.toString();
      }
    } else {
      output = message = "Please enter all the fields";
    }
    print(output);

    return [output, message, isSuccess];
  }

  Future<List> login({
    required String email,
    required String password,
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email: email, password: password);
      try {
        output = await session.post('/account/login', user);
        // print('inside login function');
        try {
          dynamic outputJson = jsonDecode(output);
          if (outputJson['login'] == true) {
            isSuccess = true;
            message = "Login successful, enter OTP to continue";
          } else {
            message = outputJson['response'];
          }
        } catch (e) {
          message = "An error occurred";
        }
      } catch (e) {
        output = e.toString();
      }
    } else {
      output = message = "Please enter all the fields";
    }
    print(output);
    return [output, message, isSuccess];
  }

  Future<List> verify({
    required String method,
    required String email,
    required String password,
    String displayName = "",
    required int otp,
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email: email, password: password, otp: otp);
      try {
        output = await session.post('/account/$method/verify', user);

        try {
          dynamic outputJson = jsonDecode(output);
          if (outputJson[method] == true) {
            isSuccess = true;
            message = "Verification successful";
          } else {
            message = outputJson['response'];
          }
        } catch (e) {
          message = "An error occurred";
        }
      } catch (e) {
        output = e.toString();
      }
    } else {
      output = message = "Please enter all the fields";
    }
    print(output);
    return [output, message, isSuccess];
  }

  // Future<List> updateUserDetails(
  //     {required String email,
  //     required String birthday,
  //     required Uint8List displayPic,
  //     required Uint8List cardPic,
  //     required String gender,
  //     required String location}) async {
  //   String output;
  //   String message = "An error occurred";
  //   bool isUpdated = false;

  //   if (email.isNotEmpty &&
  //       birthday.isNotEmpty &&
  //       location.isNotEmpty &&
  //       gender.isNotEmpty) {
  //     // User user = User(email: email, password: password);
  //     UserDetails userDetails = UserDetails(
  //       email: email,
  //       displayName: displayName,
  //       birthday: birthday,
  //       location: location,
  //       gender: gender,
  //       displayPic: displayPic,
  //       cardPic: displayPic,
  //       messages: [],
  //     );
  //     try {
  //       output = await session.post("/account/update_profile", userDetails);
  //       try {
  //         dynamic outputJson = jsonDecode(output);
  //         if (outputJson['update'] == true) {
  //           isUpdated = true;
  //           message = "Update successful!";
  //           updatedData = outputJson['updatedData'];
  //         } else {
  //           message = outputJson['response'];
  //         }
  //       } catch (e) {
  //         message = "An error occured";
  //       }
  //     } catch (e) {
  //       output = e.toString();
  //     }
  //   } else {
  //     output = message = "Please enter all fields";
  //   }
  //   return [output, message, isUpdated];
  // }
}
