import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/screens/admin/admin_account_screen.dart';
import 'package:lovelace/screens/user/account/account_settings_screen.dart';
import 'package:lovelace/screens/user/account/update_user_details_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/wide_button_arrow.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final StorageMethods _storageMethods = StorageMethods();
  final List<WideButtonArrow> wideButtonArrowList = [
    const WideButtonArrow(
        iconData: Icons.edit,
        label: "Edit Profile",
        nextScreen: UpdateUserDetailsScreen()),
    const WideButtonArrow(
        iconData: Icons.settings,
        label: "Settings",
        nextScreen: AccountSettingsScreen()),
    const WideButtonArrow(
        iconData: Icons.admin_panel_settings,
        label: "Admin Mode",
        nextScreen: AdminAccountScreen()),
  ];
  String displayName = '';
  String location = '';
  String profilePic = '';
  bool profilePicLoading = true;

  _AccountScreenState() {
    _storageMethods.read("userDetails").then((value) {
      if (value == null) {
        UserStateMethods().logoutState(context);
      }
      dynamic valueJson = json.decode(value);
      setState(() {
        displayName = valueJson["display_name"];
        location = valueJson["location"];
        profilePic = valueJson["profile_pic"];
        profilePicLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(height: 64),
                Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: profilePicLoading
                                ? Image.asset(
                                        "assets/images/default-profile-picture.png")
                                    .image
                                : Image.memory(Uint8List.fromList(
                                        base64.decode(profilePic)))
                                    .image),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(displayName,
                            style: const TextStyle(
                                fontSize: 25,
                                color: blackColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(location,
                            style: const TextStyle(
                                fontSize: 17,
                                color: placeholderColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                for (WideButtonArrow wideButtonArrow in wideButtonArrowList)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.5, horizontal: 12),
                    child: wideButtonArrow,
                  )
              ]),
        )));
  }
}
