import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/models/user.dart';
import 'package:lovelace/services/storage_service.dart';

var logger = Logger();

class AuthMethods {
  final String _baseUrl = '10.0.2.2:3000';
  Future<String> register({
    required String email,
    required String password,
  }) async {
    User user = User(email: email, password: password);
    String userJson = jsonEncode(user);
    String output = "An error occured";

    if (email.isNotEmpty || password.isNotEmpty) {
      try {
        http.Response res = await http.post(
            Uri.http(_baseUrl, '/account/create'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
            },
            body: userJson);
        output = res.body;
        dynamic outputJson = jsonDecode(output);
        if (outputJson['register'] == true) {
          String token = outputJson['token'];
          // STORE USER REGISTER CREDENTAILS IN SECURE_STORAGE
          StorageService().writeSecureData(StorageItem(token, userJson.toString()));
          debugPrint("Register data written to SECURE_STORAGE");
          return token;                    
        }
      } catch (err) {
        return err.toString();
      }
    } else {
      output = "Please enter all the fields";
    }
    debugPrint(output, wrapWidth: 1024);
    return output;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    User user = User(email: email, password: password);
    String userJson = jsonEncode(user);
    String output = "An error occured";

    if (email.isNotEmpty || password.isNotEmpty) {
      try {
        http.Response response = await http.post(
            Uri.http(_baseUrl, '/account/login'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
            },
            body: userJson);
        output = response.body;
        dynamic outputJson = jsonDecode(output);
        if (outputJson['login'] == true) {
          String token = outputJson['token'];
          // STORE USER LOGIN CREDENTAILS IN SECURE_STORAGE
          StorageService().writeSecureData(StorageItem(token, userJson.toString()));
          debugPrint("Login data written to SECURE_STORAGE");
          return token;                    
        }
        // TODO: add user state to local storage
      } catch (err) {
        return err.toString();
      }
    } else {
      output = "Invaid Input!";
    }
    debugPrint(output, wrapWidth: 1024);
    return output;
  }
}
