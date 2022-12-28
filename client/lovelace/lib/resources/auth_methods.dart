import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:logger/logger.dart';
import 'package:lovelace/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:lovelace/resources/secure_token_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:http/http.dart' as http;

var logger = Logger();
String token = "";
String updatedData = "";

Future submit(User user, String route) async {
  String baseUrl = checkDevice();
  String userJson = jsonEncode(user);
  http.Response response = await http.post(Uri.http(baseUrl, route),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
      },
      body: userJson);

  return response.body;
}

class AuthMethods {
  Future<List> register(
      {required String email,
      required String password,
      required String location,
      required String username,
      required int id,
      required int age,
      Image? profilepic}) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email: email, password: password);
      try {
        output = await submit(user, '/account/create');
        try {
          dynamic outputJson = jsonDecode(output);

          if (outputJson['creation'] == true) {
            isSuccess = true;
            message = "Registration successful";
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
            debugPrint('\nJWT Token plaintext: $token');
            StorageMethods().writeToken(token);
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

  Future<List> updateUserDetails({
    required String email,
    required String password,
    // required String username,
    // required String location
  }) async {
    String output;
    String message = "An error occurred";
    bool isUpdated = false;

    if (email.isNotEmpty && password.isNotEmpty
        // location.isNotEmpty &&
        // username.isNotEmpty
        ) {
      User user = User(email: email, password: password);
      try {
        output = await submit(user, "/account/test");
        try {
          dynamic outputJson = jsonDecode(output);
          if (outputJson['update'] == true) {
            isUpdated = true;
            message = "Update successful!";
            updatedData = outputJson['updatedData'];
          } else {
            message = outputJson['response'];
          }
        } catch (e) {
          message = "An error occured";
        }
      } catch (e) {
        output = e.toString();
      }
    } else {
      output = message = "Please enter all fields";
    }
    return [output, message, isUpdated];
  }
}
