import 'package:flutter/material.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/widgets/chat_search_delegate.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/chat_person.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<UserDetails> userDetailsList = [
    UserDetails(
      email: "lgf2111@gmail.com",
      displayName: "Lee Guan Feng",
      birthday: "21-11-2004",
      gender: "Male",
      location: "Singapore",
      profilePic: "",
      displayPic: "",
    ),
    UserDetails(
      email: "213587x@gmail.com",
      displayName: "Paimon",
      birthday: "01-01-2001",
      gender: "Female",
      location: "Singapore",
      profilePic: "",
      displayPic: "",
    )
  ];

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
                      const Text('Chat List',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor)),
                      IconButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: ChatSearchDelegate(userDetailsList));
                          },
                          icon: const Icon(
                            Icons.search,
                            color: primaryColor,
                            size: 30,
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: ListView(
                      children: <Widget>[
                        for (UserDetails userDetails in userDetailsList)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: .5),
                            child: ChatPerson(
                              time: DateTime.now(),
                              userDetails: userDetails,
                            ),
                          )
                      ],
                    ),
                  )
                ]),
          ),
        ));
  }
}
