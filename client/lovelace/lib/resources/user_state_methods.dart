import 'package:flutter/material.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
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
    print(cookie);
    List response = await _accountMethods.read();
    String output = response[0];
    String message = response[1];
    bool isSuccess = response[2];
    print("$output\n$message\n$isSuccess");

    if (isSuccess) {
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

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (BuildContext context) => const LandingScreen()),
      (Route route) => false,
    );
  }
}
