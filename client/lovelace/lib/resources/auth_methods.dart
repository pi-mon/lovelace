import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:lovelace/models/token_item.dart';
import 'package:lovelace/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:http/http.dart' as http;

var logger = Logger();
String token = "";
String updatedData = "";

Future submit(User user, String route, {token}) async {
  String baseUrl = checkDevice();
  String userJson = jsonEncode(user);
  String contentJson = userJson.substring(0, userJson.length - 1);
  if (token != null) {
    contentJson += ",\"token\":\"$token\"";
  }
  contentJson += "}";
  debugPrint(contentJson, wrapWidth: 1024);
  http.Response response = await http.post(
    Uri.http(baseUrl, route),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    },
    body: contentJson,
  );

  return response.body;
}

class AuthMethods {
  Future<List> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      User user =
          User(email: email, password: password, displayName: displayName);
      try {
        output = await submit(user, '/account/create');
        try {
          dynamic outputJson = jsonDecode(output);

          if (outputJson['creation'] == true) {
            isSuccess = true;
            message = "Enter OTP to verify your account";
            token = outputJson['token'];
            debugPrint(output);
            debugPrint(token);
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
    debugPrint(output, wrapWidth: 1024);

    return [output, message, isSuccess];
  }

  Future<List> verify({
    required String email,
    required String password,
    required String displayName,
    required int otp,
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(
          email: email, password: password, displayName: displayName, otp: otp);
      try {
        output = await submit(user, '/account/create/verify', token: token);
        try {
          dynamic outputJson = jsonDecode(output);

          if (outputJson['create'] == true) {
            isSuccess = true;
            message = "Register successful";
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
    debugPrint(output, wrapWidth: 1024);

    return [output, message, isSuccess];
  }

  Future<List> login({
    required String email,
    required String password,
    // required String username,
    // required String location,
    // required int age,
    // Image? profilepic
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email: email, password: password);
      try {
        output = await submit(user, '/account/login');
        try {
          dynamic outputJson = jsonDecode(output);

          if (outputJson['login'] == true) {
            isSuccess = true;
            message = "Login successful";
            token = outputJson['token'];
            debugPrint(output);
            debugPrint(token);
            StorageMethods().writeToken(TokenItem(key: "token", value: token));
            debugPrint("Token written to SECURE_STORAGE");
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
    debugPrint(output, wrapWidth: 1024);
    return [output, message, isSuccess];
  }

  // Future<List> updateUserDetails({ 
  //   // !! Should allow user to change displayName, email, password, age, location
  //   // !! OR are we not allowing users to change their password? (cos password not in UserDetails class)
  //   required String email,
  //   required String password,
  //   required String displayName,
  //   required String location
  // }) async {
  //   String output;
  //   String message = "An error occurred";
  //   bool isUpdated = false;

  //   if (email.isNotEmpty && password.isNotEmpty &&
  //       location.isNotEmpty &&
  //       displayName.isNotEmpty
  //       ) {
  //     User user = User(email: email, password: password);
  //     try {
  //       output = await submit(user, "/account/test");
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
