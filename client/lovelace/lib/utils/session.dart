import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

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
    checkTokenExpired(response);
    return response.body;
  }

  Future<String> post(String route, dynamic data,
      {List<Map<String, String>>? filesMap}) async {
    dynamic cookie = await _storageMethods.read("cookie") ?? "";

    if (filesMap != null) {
      headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
      headers[HttpHeaders.cookieHeader] = cookie;
      http.MultipartRequest request =
          http.MultipartRequest("POST", Uri.http(_baseUrl, route));
      request.headers.addAll(headers);
      request.fields['payload'] = jsonEncode(data);
      for (Map<String, String> fileMap in filesMap) {
        request.files.add(await http.MultipartFile.fromPath(
            fileMap["name"]!, fileMap["path"]!));
      }
      http.StreamedResponse response = await request.send();
      return response.stream.bytesToString();
    } else {
      headers[HttpHeaders.contentTypeHeader] =
          'application/json; charset=UTF-8';
      headers[HttpHeaders.cookieHeader] = cookie;

      http.Response response = await http.post(Uri.http(_baseUrl, route),
          body: jsonEncode(data), headers: headers);
      updateCookie(response);
      checkTokenExpired(response);
      return response.body;
    }
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

  bool checkTokenExpired(http.Response response) {
    String responseBody = response.body;
    try {
      dynamic responseJson = json.decode(responseBody);
      if (responseJson['message'] == "Token has expired !!") {
        _storageMethods.delete("isLoggedIn");
        _storageMethods.delete("isFTL");
        _storageMethods.delete("cookie");
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
