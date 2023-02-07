import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/storage_methods.dart';

import 'package:lovelace/widgets/chat_stream_socket.dart';
import 'package:lovelace/widgets/message_tile.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.receiverEmail});
  final String receiverEmail;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  UserDetails senderUserDetails = UserDetails(
    email: "lgf2111@gmail.com",
    displayName: "Lee Guan Feng",
    birthday: "21-11-2004",
    gender: "Male",
    location: "Singapore",
    profilePic: "",
    displayPic: "",
  );
  UserDetails receiverUserDetails = UserDetails(
    email: "213587x@gmail.com",
    displayName: "Paimon",
    birthday: "01-01-2001",
    gender: "Female",
    location: "Singapore",
    profilePic: "",
    displayPic: "",
  );
  String keyName = "";
  StreamingSharedPreferences? preferences;
  Preference<String>? content;
  String initialData = "[]";

  ChatStreamSocket chatStreamSocket = ChatStreamSocket();
  StorageMethods storageMethods = StorageMethods();

  TextEditingController messageController = TextEditingController();

  Future<void> getContent() async {
    preferences = await StreamingSharedPreferences.instance;
    content = preferences!.getString(keyName, defaultValue: "[]");
    setState(() {
      initialData = content!.getValue();
    });
    print(initialData); // returns the messages in the chat
  }

  getSenderUserDetails() async {
    dynamic senderUserDetailsJson = await storageMethods.read("userDetails");
    senderUserDetails =
        UserDetails.fromJson(json.decode(senderUserDetailsJson));
  }

  _ChatRoomScreenState() {
    getSenderUserDetails();
    List<String> emails = <String>[
      senderUserDetails.email,
      receiverUserDetails.email
    ];
    emails.sort();
    keyName = "${emails[0]}&${emails[1]}";
    connectAndListen(
        senderUserDetails.email, receiverUserDetails.email, keyName);
    getContent();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    disconnect(senderUserDetails.email, receiverUserDetails.email, keyName);
  }

  dynamic chatMessages() {
    return StreamBuilder(
      initialData: initialData,
      stream: content,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          dynamic messages = json.decode(snapshot.data);
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              int revIndex = messages.length - index - 1;
              MessageTile messageTile = MessageTile(
                  message: messages[revIndex]['message'],
                  sender: messages[revIndex]['sender'],
                  sentByMe: senderUserDetails.displayName ==
                      messages[revIndex]['sender'],
                  time: messages[revIndex]['time']);
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: messageTile,
                );
              }
              return messageTile;
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  dynamic sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": senderUserDetails.displayName,
        "receiver": receiverUserDetails.displayName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      dynamic oldContent = json.decode(content!.getValue());
      oldContent.add(chatMessageMap);
      String newContent = json.encode(oldContent);
      content!.setValue(newContent);
      print('newContent: $newContent');
      chatMessageMap.addAll({
        "room": keyName,
      });

      print(content);
      sendingMessage(
          chatMessageMap, senderUserDetails.email, receiverUserDetails.email);
      storageMethods.write("message", newContent);
      // storageMethods.read("message");
      setState(() {
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 64,
        title: Text(receiverUserDetails.displayName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Clear chat history"),
                        content: const Text("Are you sure?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                content!.setValue("[]");
                                Navigator.pop(context);
                              },
                              child: const Text("Confirm")),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[500],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
