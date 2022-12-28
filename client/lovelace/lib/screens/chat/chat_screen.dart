import 'package:flutter/material.dart';
import 'package:lovelace/screens/chat/chat_room.dart';
import 'package:lovelace/screens/chat/chat_room_v2.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/contact_item.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final email = "test@gmail.com";
  final password = "";

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
                  const Text('Chats',
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: primaryColor)),
                  TextFieldInput(
                      textEditingController: _searchController,
                      label: "",
                      hintText: "Search",
                      textInputType: TextInputType.text,
                      validator: (value) {}),
                  Flexible(
                    child: Column(
                      children: const <Widget>[
                        SizedBox(
                          height: 50,
                            child: ContactItem(
                              time: "12:00 PM",
                              contact: "Sarah",
                              lastText: "Hello there!",
                            ),                        
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                            child: ContactItem(
                              time: "12:00 PM",
                              contact: "John",
                              lastText: "Hello there!",
                            ),                          
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                            child: ContactItem(
                              time: "12:00 PM",
                              contact: "Dylan",
                              lastText: "Hello there!",
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
