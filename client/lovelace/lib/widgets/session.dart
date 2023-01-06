import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/global_variables.dart';

class Session {
  final _storageMethods = StorageMethods();
  final String _baseUrl = checkDevice();

  Map<String, String> headers = {};

  Future<String> get(String route) async {
    dynamic cookie = await _storageMethods.read("cookie");

    if (cookie != null) {
      headers[HttpHeaders.cookieHeader] = cookie;
    }
    http.Response response =
        await http.get(Uri.http(_baseUrl, route), headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future<String> post(String route, dynamic data) async {
    debugPrint('inside post function');
    dynamic cookie = await _storageMethods.read("cookie");

    headers[HttpHeaders.contentTypeHeader] = 'application/json; charset=UTF-8';
    if (cookie != null) {
      headers[HttpHeaders.cookieHeader] = cookie;
    }    
    debugPrint('${data.runtimeType}');
    // if (data.runtimeType == UserDetails) { // JSON encode data before storing object
    //   // TODO: Store the user object in local storage
    // }
    http.Response response = await http.post(Uri.http(_baseUrl, route),
        body: jsonEncode(data), headers: headers);
    updateCookie(response);
    return response.body;
  }

  void updateCookie(http.Response response) async {
    String? rawCookie = response.headers[HttpHeaders.setCookieHeader];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers[HttpHeaders.cookieHeader] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
      bool isStored = await _storageMethods.write("cookie", rawCookie);
    }
  }
}
