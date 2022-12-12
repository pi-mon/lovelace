import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/account_details_screen.dart';
import 'package:lovelace/screens/user/account_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:http/http.dart' as http;

class ViewLogsDetailScreen extends StatefulWidget {
  final String name;
  const ViewLogsDetailScreen({super.key, required this.name});

  @override
  State<ViewLogsDetailScreen> createState() => _ViewLogsDetailScreenState();
}

Future getLogs(String route) async {
  String baseUrl = checkDevice();
  http.Response response = await http.get(Uri.https(baseUrl, route));
  dynamic responseJson = jsonDecode(response.body);
  return responseJson.toString();
}

class _ViewLogsDetailScreenState extends State<ViewLogsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Future snapshot = getLogs("/logs/${widget.name}");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false, // hides the back arrow
          title: Text("View ${widget.name} logs"),
          toolbarHeight: 64,
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: snapshot,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(snapshot.data),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}
