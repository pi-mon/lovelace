import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:lovelace/resources/storage_methods.dart';

var logger = Logger();
String token = "";

String checkDevice() {
  String baseUrl = "127.0.0.1";
  if (defaultTargetPlatform == TargetPlatform.android) {
    baseUrl == "10.0.2.2";
  }
  return "$baseUrl:3000";
}

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
  Future<List> register({
    required String email,
    required String password,
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    String _baseUrl = checkDevice();
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
  }) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    String _baseUrl = checkDevice();
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
            StorageMethods().writeSecureData(StorageItem(token, token));
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
}
