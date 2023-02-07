import 'package:flutter/material.dart';
import 'package:lovelace/screens/admin/view_logs_screen.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:lovelace/widgets/wide_button_arrow.dart';

class AdminAccountScreen extends StatefulWidget {
  const AdminAccountScreen({super.key});

  @override
  State<AdminAccountScreen> createState() => _AdminAccountScreenState();
}

class _AdminAccountScreenState extends State<AdminAccountScreen> {
  List<WideButtonArrow> wideButtonArrowList = [
    WideButtonArrow(
        iconData: Icons.person,
        label: "User Mode",
        nextScreen: userPages,
        isAdmin: true),
    WideButtonArrow(
      iconData: Icons.track_changes,
      label: "View Logs",
      nextScreen: ViewLogsScreen(),
    ),
  ];

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
                  for (WideButtonArrow wideButtonArrow in wideButtonArrowList)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.5, horizontal: 12),
                      child: wideButtonArrow,
                    ),
                ])),
      ),
    );
  }
}
