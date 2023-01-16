import 'package:flutter/material.dart';
import 'package:lovelace/screens/admin/view_logs_detail_screen.dart';
import 'package:lovelace/utils/colors.dart';

class ViewLogsScreen extends StatefulWidget {
  const ViewLogsScreen({super.key});

  @override
  State<ViewLogsScreen> createState() => _ViewLogsScreenState();
}

class _ViewLogsScreenState extends State<ViewLogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: primaryColor,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)),
            title: const Text("View Logs",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ViewLogsDetailScreen(name: "root")));
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Root Logs',
                              style:
                                  TextStyle(fontSize: 20, color: blackColor)),
                          Icon(
                            Icons.arrow_right,
                            color: placeholderColor,
                            size: 40,
                          )
                        ],
                      ),
                    )),
                SizedBox(
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ViewLogsDetailScreen(
                                        name: "account")));
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Account Logs',
                              style:
                                  TextStyle(fontSize: 20, color: blackColor)),
                          Icon(
                            Icons.arrow_right,
                            color: placeholderColor,
                            size: 40,
                          )
                        ],
                      ),
                    )),
                SizedBox(
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ViewLogsDetailScreen(name: "chat")));
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Chatroom Logs',
                              style:
                                  TextStyle(fontSize: 20, color: blackColor)),
                          Icon(
                            Icons.arrow_right,
                            color: placeholderColor,
                            size: 40,
                          )
                        ],
                      ),
                    )),
                SizedBox(
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ViewLogsDetailScreen(
                                        name: "recommendation")));
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text('Recommendation Logs',
                              style:
                                  TextStyle(fontSize: 20, color: blackColor)),
                          Icon(
                            Icons.arrow_right,
                            color: placeholderColor,
                            size: 40,
                          )
                        ],
                      ),
                    )),
              ]),
        )));
  }
}
