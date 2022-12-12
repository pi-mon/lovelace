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
  String _baseUrl = "";
  
  if (defaultTargetPlatform == TargetPlatform.android) {
    _baseUrl == "10.0.2.2:3000";
  }
  else {
    _baseUrl == "127.0.0.1:3000";
  }
  return _baseUrl;
}


Future submit(User user, String route) async {
  String _baseUrl;
  String userJson = jsonEncode(user);
  // String _baseUrl = checkDevice();
  // http.Response response = await http.post(Uri.https(_baseUrl, route),
  http.Response response = await http.post(Uri.http(_baseUrl = checkDevice(), route),
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
    bool success = false;

    String _baseUrl = checkDevice();
    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email: email, password: password);
      try {
        output = await submit(user, '/account/create');
        try {
          dynamic outputJson = jsonDecode(output);

          if (outputJson['creation'] == true) {
            success = true;
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

    return [output, message, success];
  }

  Future<List> login({        
    required String email,
    required String password,
  }) async {
    String output;
    String message = "An error occurred";
    bool success = false;

    String _baseUrl = checkDevice();
    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email: email, password: password);
      try {
        output = await submit(user, '/account/login');
        try {
          dynamic outputJson = jsonDecode(output);

          if (outputJson['login'] == true) {
            success = true;
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
    return [output, message, success];
  }
}
