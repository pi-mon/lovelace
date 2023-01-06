import 'package:flutter/material.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/screens/user/account/update_user_details_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/account_settings_btn.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  bool _isLoading = false;
  final StorageMethods _storageMethods = StorageMethods();

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() async {
    await _storageMethods.readAllJson();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          CustomButton(
              icon: const Icon(Icons.edit, color: placeholderColor),
              label: "Update user details",
              labelColor: blackColor,
              function: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const UpdateUserDetailsScreen();
                  }))),
          CustomButton(
              icon: const Icon(Icons.backup, color: placeholderColor),
              label: "Backup my data",
              labelColor: blackColor,
              function: () {}),
          CustomButton(
              icon: const Icon(Icons.exit_to_app, color: placeholderColor),
              label: "Logout",
              labelColor: errorColor,
              function: () async {
                setState(() {
                  _isLoading = true;
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: Row(
                        children: const <Widget>[
                          SizedBox(
                              height: 14,
                              width: 14,
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 4,
                              )),
                          SizedBox(width: 15),
                          Text('Logging out...',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                        ],
                      ));
                    });
                // StorageMethods().deleteAll();
                StorageMethods().delete("cookie");
                UserStateMethods().logoutState(context);
                initList();
              })
        ])),
      ),
    );
  }
}
