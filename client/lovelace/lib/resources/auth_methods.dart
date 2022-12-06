import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lovelace/models/user.dart';

class AuthMethods {
  final String _baseUrl = '127.0.0.1:5000';
  Future<String> register({
    required String email,
    required String password,
  }) async {
    User user = User(email: email, password: password);
    String userJson = jsonEncode(user);
    String res = "An error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        http.Response response = await http.post(
            Uri.http(_baseUrl, '/register'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
            },
            body: userJson);
        if (response.statusCode != 200) {
          res = "Server error";
        } else {
          res = response.body;
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    User user = User(email: email, password: password);
    String userJson = jsonEncode(user);
    String res = "An error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        http.Response response = await http.post(Uri.http(_baseUrl, '/login'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
            },
            body: userJson);
        if (response.statusCode != 200) {
          res = "Server error";
        } else {
          res = response.body;
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
