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
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();

    _storageMethods.write("isLoggedIn", true);
    // sharedPreferences.setBool('isLoggedIn', true);

    // String cookie = await _storageMethods.read("cookie");
    // debugPrint(cookie);
    List response = await _accountMethods.read();
    // String output = response[0]; // The JSON object from server side
    // String message = response[1];
    bool isSuccess = response[2];
    // debugPrint("$output\n$message\n$isSuccess");

    if (isSuccess) {
      // var userString = jsonEncode(output);
      // _storageMethods.write("user", userString);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => userPages));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const InitBirthayScreen()),
          (route) => false);
    }
  }

  void logoutState(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('isLoggedIn', false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (BuildContext context) => const LandingScreen()),
      (Route route) => false,
    );
  }
}
