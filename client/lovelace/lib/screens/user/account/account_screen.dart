import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/screens/admin/admin_account_screen.dart';
import 'package:lovelace/screens/user/account/account_settings_screen.dart';
import 'package:lovelace/utils/colors.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final StorageMethods _storageMethods = StorageMethods();
  String displayName = '';
  String location = '';
  String profilePic = '';
  bool profilePicLoading = true;

  _AccountScreenState() {
    _storageMethods.read("userDetails").then((value) {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
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
                    const SizedBox(height: 10),
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
                Column(
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const AdminAccountScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.admin_panel_settings),
                            SizedBox(width: 10),
                            Text('Turn On Admin',
                                style: TextStyle(fontSize: 17))
                          ],
                        )),
                    const SizedBox(height: 5),
                    // ElevatedButton(
                    //     onPressed: () {},
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: primaryColor),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: const <Widget>[
                    //         Icon(Icons.person),
                    //         SizedBox(width: 10),
                    //         Text('Button 2', style: TextStyle(fontSize: 17))
                    //       ],
                    //     )),
                    // const SizedBox(height: 5),
                    // ElevatedButton(
                    //     onPressed: () {},
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: primaryColor),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: const <Widget>[
                    //         Icon(Icons.person),
                    //         SizedBox(width: 10),
                    //         Text('Button 3', style: TextStyle(fontSize: 17))
                    //       ],
                    //     )),
                  ],
                ),
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style:
                          ElevatedButton.styleFrom(backgroundColor: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('My Ideal Person',
                              style:
                                  TextStyle(fontSize: 17, color: blackColor)),
                          Icon(Icons.arrow_right, color: placeholderColor)
                        ],
                      ),
                    )),
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AccountDetailsScreen()));
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Account Settings',
                              style:
                                  TextStyle(fontSize: 17, color: blackColor)),
                          Icon(Icons.arrow_right, color: placeholderColor)
                        ],
                      ),
                    )),
              ]),
        )));
  }
}
