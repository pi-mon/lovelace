import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:crypto/crypto.dart';

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
      {bool isFilePath = false}) async {
    dynamic cookie = await _storageMethods.read("cookie");

    if (cookie != null) {
      headers[HttpHeaders.cookieHeader] = cookie;
    }

    if (isFilePath) {
      String fileBase64 = base64.encode(File(data[1]).readAsBytesSync());
      print(fileBase64);
      String hash = sha512.convert(utf8.encode(fileBase64)).toString();
      print(hash);
      headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
      http.MultipartRequest request =
          http.MultipartRequest("POST", Uri.http(_baseUrl, route));
      request.headers.addAll(headers);
      request.fields['payload'] = jsonEncode(data);
      request.fields['hash'] = hash;
      request.files.add(await http.MultipartFile.fromPath(data[0], data[1]));
      http.StreamedResponse response = await request.send();
      return response.stream.bytesToString();
    } else {
      headers[HttpHeaders.contentTypeHeader] =
          'application/json; charset=UTF-8';

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

  void checkTokenExpired(http.Response response) {
    String responseBody = response.body;
    try {
      dynamic responseJson = json.decode(responseBody);
      if (responseJson['message'] == "Token has expired !!") {
        List<String> deleteList = ["isLoggedIn", "isFTL", "cookie"];
        for (String key in deleteList) {
          _storageMethods.delete(key);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
