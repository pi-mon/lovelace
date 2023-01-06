import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovelace/widgets/message_tile.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.receiverName});
  final String receiverName;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState(receiverName);
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  _ChatRoomScreenState(this.receiverName) {
    receiverName = receiverName;
    keyName = "\"$senderName\"->\"$receiverName\"";
    getContent();
  }

  // final Session _session = Session();
  // final StorageMethods _storageMethods = StorageMethods();
  String senderName = "Guan Feng";
  String receiverName = "";
  String keyName = "";

  StreamingSharedPreferences? preferences;
  Preference<String>? content;
  String initializedData = "[]";

  // Stream<dynamic>? content;
  TextEditingController messageController = TextEditingController();
  // socket_io.Socket? socket;

  Future<void> getContent() async {
    preferences = await StreamingSharedPreferences.instance;
    content = preferences!.getString(keyName, defaultValue: "[]");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(receiverName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info))],
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

  chatMessages() {
    return StreamBuilder(
      initialData: initializedData,
      stream: content,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          dynamic messages = json.decode(snapshot.data);
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageTile(
                  message: messages[index]['message'],
                  sender: messages[index]['sender'],
                  sentByMe: senderName == messages[index]['sender']);
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

  sendMessage() async {
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

      // DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
