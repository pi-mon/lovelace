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
  bool isSuccess = true;
  bool isEmpty = true;
  String message = '';

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
                dynamic chatDataString = jsonDecode(chatDataJson);
                // Write data to file
                _backupMethods.writeJsonFile(chatDataString);
                setState(() {
                  isSuccess = true;
                });
                message = "Data is backed up!";
                // notify user of successful backup
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  backgroundColor: isSuccess ? successColor : errorColor,
                ));
              }),
          WideButton(
              icon: const Icon(Icons.info, color: placeholderColor),
              label: "Restore backed up data",
              onPressed: () async {
                final response = await _backupMethods.readJsonFile();
                message = "Restoring backed up data...";
                // print(response); // expecting to return the messages in plaintext                
                if (response == false) {
                  message = "No data found! Create a backup!";
                  print(message);
                  setState(() {
                    isSuccess = false;
                  });
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  backgroundColor: isSuccess ? blackColor : errorColor,
                ));
                // TODO: Send data in that back up copy to update function to update chat data
              }),
          WideButton(
              icon: const Icon(Icons.exit_to_app, color: placeholderColor),
              label: "Logout",
              onPressed: () async {
                // Make another back up before logging out in case
                dynamic chatDataJson = await storageMethods.read("message");
                List chatDataString = jsonDecode(chatDataJson);

                // Write data to file
                // _backupMethods.writeJsonFile();
                setState(() {
                  isSuccess = true;
                });
                UserStateMethods().logoutState(context);
                _storageMethods.readAllJson().then((value) => print(value));
              })
        ])),
      ),
    );
  }
}
