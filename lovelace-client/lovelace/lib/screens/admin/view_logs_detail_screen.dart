import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/utils/session.dart';

class ViewLogsDetailScreen extends StatefulWidget {
  final String name;

  const ViewLogsDetailScreen({super.key, required this.name});

  @override
  State<ViewLogsDetailScreen> createState() => _ViewLogsDetailScreenState();
}

class _ViewLogsDetailScreenState extends State<ViewLogsDetailScreen> {
  late ScrollController _scrollController;
  bool showBackToTopButton = false;
  Session session = Session();
  Future snapshot = Future.value("");
  int count = 0;
  int limit = 0;
  String next = "";
  String previous = "";
  List<dynamic> results = [];

  Future getLogs(String route) async {
    String responseBody = await session.get(route);
    try {
      print("responseBody: $responseBody");
      dynamic responseJson = jsonDecode(responseBody);
      setState(() {
        snapshot = Future.value(responseBody);
        count = responseJson["count"];
        limit = responseJson["limit"];
        next = responseJson["next"];
        previous = responseJson["previous"];
        results = responseJson["results"];
      });
      print(next);
      // return responseJson.toString();
    } catch (FormatException) {
      print("An error occured");
      // return "An error occured";
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            showBackToTopButton = true; // show the back-to-top button
          } else {
            showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
    getLogs("/logs/${widget.name}/1/20");
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false, // hides the back arrow
          title: Text("View ${widget.name} logs",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          toolbarHeight: 64,
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: snapshot,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (previous.isNotEmpty)
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    onPressed: () => getLogs(previous),
                                    child: const Text("Previous")),
                              if (next.isNotEmpty)
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    onPressed: () => getLogs(next),
                                    child: const Text("Next")),
                            ],
                          ),
                          for (var i = 0; i < results.length; i++)
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name: ${results[i]["name"]}"),
                                    Text("Level: ${results[i]["levelname"]}"),
                                    Text("Time: ${results[i]["asctime"]}"),
                                    Text("Message: ${results[i]["message"]}"),
                                  ],
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (previous.isNotEmpty)
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    onPressed: () {
                                      getLogs(previous);
                                      _scrollToTop();
                                    },
                                    child: const Text("Previous")),
                              if (next.isNotEmpty)
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    onPressed: () {
                                      getLogs(next);
                                      _scrollToTop();
                                    },
                                    child: const Text("Next")),
                            ],
                          )
                        ]),
                    // child: Text(snapshot.data),
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
