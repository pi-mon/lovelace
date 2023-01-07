import 'package:flutter/material.dart';
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
    bool isSuccess = response[2];
    _storageMethods.write("isFTL", !isSuccess);
    if (isSuccess) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => userPages));
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const InitDisplayNameScreen()),
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
