import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/backup_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/wide_button.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final StorageMethods _storageMethods = StorageMethods();
  final BackupMethods _backupMethods = BackupMethods();
  bool isSuccess = false;
  String message = "Data is backed up!";

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
          title: const Text("Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: Column(children: <Widget>[
          WideButton(
              icon: const Icon(Icons.backup, color: placeholderColor),
              label: "Backup my data",
              onPressed: () async {
                dynamic chatDataJson = await storageMethods.read("message");
                dynamic userDataJson = await storageMethods.read("userDetails");
                UserDetails userData =
                    UserDetails.fromJson(jsonDecode(userDataJson));
                List chatDataString = jsonDecode(chatDataJson);

                // Write data to file
                _backupMethods.writeJsonFile(
                    userData.email,
                    userData.displayName,
                    userData.gender,
                    userData.birthday,
                    userData.location,
                    chatDataString);
                setState(() {
                  isSuccess = true;
                });                
                // notify user of successful backup
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  backgroundColor: isSuccess ? successColor : errorColor,
                ));
              }),
          WideButton(
              icon: const Icon(Icons.info, color: placeholderColor),
              label: "Read backed up data",
              onPressed: () {
                _backupMethods.readJsonFile();
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
