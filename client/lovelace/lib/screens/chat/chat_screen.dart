import 'package:flutter/material.dart';
import 'package:lovelace/resources/search_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/contact_item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Chats',
                          style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: primaryColor)),
                      IconButton(
                          onPressed: () {
                            showSearch(
                                context: context, delegate: MySearchDelegate());
                          },
                          icon: const Icon(
                            Icons.search,
                            color: primaryColor,
                            size: 30,
                          ))
                    ],
                  ),
                  const Divider(
                    color: placeholderColor,
                    height: 25,
                    thickness: 2,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Flexible(
                    child: Column(
                      children: const <Widget>[
                        SizedBox(
                          height: 50,
                          child: ContactItem(
                            time: "12:00 PM",
                            contact: "Sarah",
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ContactItem(
                            time: "12:00 PM",
                            contact: "John",
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
        ));
  }
}
