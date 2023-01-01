import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/screens/main/landing_screen.dart';
import 'package:lovelace/screens/user/initialise/init_birthday_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lovelace/utils/global_variables.dart';

class UserStateMethods {
  final AccountMethods _accountMethods = AccountMethods();
  final StorageMethods _storageMethods = StorageMethods();

  void loginState(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('isLoggedIn', true);

    String cookie = await _storageMethods.read("cookie");
    debugPrint(cookie);
    List response = await _accountMethods.read();
    String output = response[0]; // return user details as string
    String message = response[1];
    bool isSuccess = response[2];
    debugPrint("\n$output\n$message\n$isSuccess");    

    if (isSuccess) {
      // var userString = jsonEncode(output);
      // _storageMethods.write("user", userString);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => userPages));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InitBirthayScreen()));
    }
  }

  void logoutState(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    // await Future.delayed(const Duration(seconds: 2));
    sharedPreferences.setBool('isLoggedIn', false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (BuildContext context) => const LandingScreen()),
      (Route route) => false,
    );
  }
}
