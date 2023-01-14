import 'package:flutter/material.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/screens/user/account/update_user_details_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/wide_button.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final StorageMethods _storageMethods = StorageMethods();
  bool isBackedup = true;

  _AccountSettingsScreenState() {
    _storageMethods.readAllJson().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Account Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: Column(children: <Widget>[
          // WideButton(
          //     icon: const Icon(Icons.edit, color: placeholderColor),
          //     label: "Update user details",
          //     onPressed: () =>
          //         Navigator.push(context, MaterialPageRoute(builder: (context) {
          //           return const UpdateUserDetailsScreen();
          //         }))),
          WideButton(
              icon: const Icon(Icons.backup, color: placeholderColor),
              label: "Backup my data",
              onPressed: () async {
                // TODO: get the user data and call the BackupMethods
                // final userData = storageMethods.read("userDetails");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Backing up data...'),
                    backgroundColor:
                        const SnackBarThemeData().backgroundColor));

                // wait for BackupMethods to complete
                // notify user of successful backup
              }),
          WideButton(
              icon: const Icon(Icons.info, color: placeholderColor),
              label: "Read backed up data",
              onPressed: () {
                // TODO: Read data from local file
              }),
          WideButton(
              icon: const Icon(Icons.exit_to_app, color: placeholderColor),
              label: "Logout",
              onPressed: () async {
                UserStateMethods().logoutState(context);
                _storageMethods.readAllJson().then((value) => print(value));
                storageMethods.deleteAll();
              })
        ])),
      ),
    );
  }
}
