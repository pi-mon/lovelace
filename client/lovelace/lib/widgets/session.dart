import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  String baseUrl = checkDevice();

  Map<String, String> headers = {};

  Future<String> get(String route) async {
    dynamic cookie = await StorageMethods().read("cookie");

    if (cookie != null) {
      headers[HttpHeaders.cookieHeader] = cookie;
    }
    http.Response response =
        await http.get(Uri.http(baseUrl, route), headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future<String> post(String route, dynamic data) async {
    dynamic cookie = await StorageMethods().read("cookie");

    headers[HttpHeaders.contentTypeHeader] = 'application/json; charset=UTF-8';
    if (cookie != null) {
      headers[HttpHeaders.cookieHeader] = cookie;
    }
    http.Response response = await http.post(Uri.http(baseUrl, route),
        body: json.encode(data), headers: headers);
    updateCookie(response);
    return response.body;
  }

  void updateCookie(http.Response response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? rawCookie = response.headers[HttpHeaders.setCookieHeader];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers[HttpHeaders.cookieHeader] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
      bool isStored = await StorageMethods().write("cookie", rawCookie);
      print("Cookie ${isStored ? "" : "not"} stored");
    }
  }
}
