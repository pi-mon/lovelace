import 'package:flutter/material.dart';
import 'package:lovelace/screens/admin/admin_account_screen.dart';
import 'package:lovelace/screens/user/account_settings_screen.dart';
import 'package:lovelace/utils/colors.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[Icon(Icons.person, size: 60)]),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Name',
                            style: TextStyle(
                                fontSize: 25,
                                color: blackColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Location',
                            style: TextStyle(
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminAccountScreen()));
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
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Text('Button 2', style: TextStyle(fontSize: 17))
                          ],
                        )),
                    const SizedBox(height: 5),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Text('Button 3', style: TextStyle(fontSize: 17))
                          ],
                        )),
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
                        // TODO: DISPLAY TOKEN IN POP UP
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
