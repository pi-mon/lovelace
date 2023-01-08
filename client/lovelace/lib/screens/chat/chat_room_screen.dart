import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:lovelace/widgets/chat_stream_socket.dart';
import 'package:lovelace/widgets/message_tile.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.receiverName});
  final String receiverName;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState(receiverName);
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  String senderName = "Guan Feng";
  String receiverName = "";
  String keyName = "";

  StreamingSharedPreferences? preferences;
  Preference<String>? content;
  String initialData = "[]";

  ChatStreamSocket chatStreamSocket = ChatStreamSocket();

  TextEditingController messageController = TextEditingController();

  Future<void> getContent() async {
    preferences = await StreamingSharedPreferences.instance;
    content = preferences!.getString(keyName, defaultValue: "[]");
    setState(() {
      initialData = content!.getValue();
    });
  }

  _ChatRoomScreenState(this.receiverName) {
    receiverName = receiverName;
    List<String> names = <String>[senderName, receiverName];
    names.sort();
    keyName = "\"${names[0]}\"&\"${names[1]}\"";
    connectAndListen(keyName, senderName);
    getContent();
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
                  sentByMe: senderName == messages[revIndex]['sender'],
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
        "sender": senderName,
        "receiver": receiverName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      dynamic oldContent = json.decode(content!.getValue());
      oldContent.add(chatMessageMap);
      String newContent = json.encode(oldContent);
      content!.setValue(newContent);

      chatMessageMap.addAll({
        "room": keyName,
      });

      sendingMessage(chatMessageMap);
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
        title: Text(receiverName),
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
