import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/models/user.dart';
import 'package:lovelace/resources/storage_methods.dart';

var logger = Logger();

class AuthMethods {
  final String _baseUrl = '10.0.2.2:3000';
  Future<List> register({
    required String email,
    required String password,
  }) async {
    String output;
    String message = "An error occurred";
    bool success = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email: email, password: password);
      String userJson = jsonEncode(user);
      try {
        http.Response res = await http.post(
            Uri.http(_baseUrl, '/account/create'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
            },
            body: userJson);

        output = res.body;
        dynamic outputJson = jsonDecode(output);

        if (outputJson['creation'] == true) {
          success = true;
          message = "Registration successful";
        } else {
          message = outputJson['response'];
        }
      } catch (err) {
        output = err.toString();
      }
    } else {
      output = "Please enter all the fields";
      message = "Please enter all the fields";
    }
    debugPrint(output, wrapWidth: 1024);

    return [output, message, success];
  }

  Future<List> login({
    required String email,
    required String password,
    String token = ""
  }) async {
    String output;
    String message = "An error occurred";
    bool success = false;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        User user = User(email: email, password: password);
        String userJson = jsonEncode(user);

        http.Response response = await http.post(
            Uri.http(_baseUrl, '/account/login'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
            },
            body: userJson);

        output = response.body;
        dynamic outputJson = jsonDecode(output);
        debugPrint("Test");
        if (outputJson['login'] == true) {
          success = true;
          message = "Login successful";

          token = outputJson['token'];
          debugPrint("Token: $token");
          StorageMethods().writeSecureData(StorageItem(token, token));
          debugPrint("Token written to SECURE_STORAGE");
          // StorageMethods().readSecureData(token);
        } else {
          message = outputJson['response'];
        }
      } catch (err) {
        output = err.toString();
        message = "Invalid email or password";
      }
    } else {
      output = "Please enter all the fields";
      message = "Please enter all the fields";
    }
    debugPrint(output, wrapWidth: 1024);
    return [output, message, success];
  }
}
