import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/backup_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/wide_button.dart';
import 'package:path_provider/path_provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final StorageMethods _storageMethods = StorageMethods();
  final BackupMethods _backupMethods = BackupMethods();
  bool isSuccess = false;
  String message = '';

  Future<bool> _fileExists() async {
    Directory? directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/user-data.json');
    // print(file.exists());
    return file.exists();
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
                message = "Data is backed up!";
                // notify user of successful backup
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  backgroundColor: isSuccess ? successColor : errorColor,
                ));
              }),
          WideButton(
              icon: const Icon(Icons.info, color: placeholderColor),
              label: "Read backed up data",
              onPressed: () async {
                final fileExists = await _fileExists();

                if (fileExists == true) {
                  setState(() {
                    isSuccess = true;
                  });
                  message = 'Reading backed up data...';
                  final data = _backupMethods.readJsonFile();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                    backgroundColor: isSuccess ? successColor : errorColor,
                  ));
                } else {
                  setState(() {
                    isSuccess = false;
                  });
                  // notify user to back up data first
                  message = 'The file does not exist! Back up your data first!';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                    backgroundColor: isSuccess ? successColor : errorColor,
                  ));
                }
              }),
          WideButton(
              icon: const Icon(Icons.exit_to_app, color: placeholderColor),
              label: "Logout",
              onPressed: () async {
                // Make another back up before logging out in case
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
                UserStateMethods().logoutState(context);
                _storageMethods.readAllJson().then((value) => print(value));
                storageMethods.deleteAll();
              })
        ])),
      ),
    );
  }
}
