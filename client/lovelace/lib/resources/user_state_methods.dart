import 'dart:convert';
import 'dart:typed_data';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:flutter/material.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/screens/main/landing_screen.dart';
import 'package:lovelace/screens/user/initialise/init_display_name_screen.dart';
import 'package:lovelace/utils/global_variables.dart';

final StorageMethods _storageMethods = StorageMethods();
final AccountMethods _accountMethods = AccountMethods();

class UserStateMethods {
  void loginState(BuildContext context) async {
    _storageMethods.write("isLoggedIn", true);
    List response = await _accountMethods.read();
    String output = response[0];
    bool isSuccess = response[2];
    print(isSuccess);
    _storageMethods.write("isFTL", !isSuccess);
    if (isSuccess) {
      // If user is already registered
      UserDetails userDetails =
          UserDetails.fromJson(json.decode(output)["response"]);
      print(userDetails);
      _storageMethods.write("userDetails", userDetails);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => userPages));
      storageMethods.delete("pin"); // delete pin from secure storage after encrypting data
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const InitDisplayNameScreen()),
          (route) => false);
    }
  }

  void logoutState(BuildContext context) async {
    List<String> keyList = ["isLoggedIn", "isFTL", "userDetails"];
    for (String key in keyList) {
      _storageMethods.delete(key);
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("You have been logged out"),
    ));

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (BuildContext context) => const LandingScreen()),
      (Route route) => false,
    );
  }
}
