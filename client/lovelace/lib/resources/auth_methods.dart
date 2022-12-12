import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:network_info_plus/network_info_plus.dart';

var logger = Logger();
String token = "";
String _baseUrl = "10.0.2.2:3000";

// GET IP ADDRESS OF LOCAL DEVICE
// void getLocalIP() async {
//   await NetworkInfo().getWifiIP();
// }

// void checkDevice() {
//   if (defaultTargetPlatform == TargetPlatform.android) {
//     _baseUrl == "10.0.2.2:3000";
//     return _baseUrl;
//   }
//   else {
//     _baseUrl == "127.0.0.1:3000";
//     return _baseUrl;
//   }
// }


Future submit(User user, String route) async {
  String userJson = jsonEncode(user);

  // http.Response response = await http.post(Uri.https(_baseUrl, route),
  http.Response response = await http.post(Uri.http(_baseUrl, route),
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

    debugPrint("Inside AuthMethods");
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
            debugPrint("Token: $token");
            StorageMethods().writeSecureData(StorageItem("token", token));
            debugPrint("Login data written to SECURE_STORAGE");
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
