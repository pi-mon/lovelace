import 'package:flutter/material.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/screens/main/landing_screen.dart';
import 'package:lovelace/screens/user/initialise/init_birthday_screen.dart';
import 'package:lovelace/utils/global_variables.dart';

final StorageMethods _storageMethods = StorageMethods();
final AccountMethods _accountMethods = AccountMethods();

class UserStateMethods {
  void loginState(BuildContext context) async {
    _storageMethods.write("isLoggedIn", true);
    List response = await _accountMethods.read();
    bool isSuccess = response[2];
    if (isSuccess) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => userPages));
    } else {
      _storageMethods.write("isFTL", true);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const InitBirthayScreen()),
          (route) => false);
    }
  }

  void logoutState(BuildContext context) async {
    _storageMethods.write("isLoggedIn", false);
    // notify user that user has been logged out

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
