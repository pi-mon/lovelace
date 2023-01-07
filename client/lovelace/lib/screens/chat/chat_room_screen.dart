import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lovelace/models/message.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/colors.dart';
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
  final StorageMethods storageMethods = StorageMethods();
  List<Message> messageList = [];
  DateFormat dateFormat = DateFormat('yyyy-MM-dd - kk:mm');

  _ChatRoomScreenState(this.receiverName) {
    receiverName = receiverName;
    List<String> names = <String>[senderName, receiverName];
    names.sort();
    keyName = "\"${names[0]}\":\"${names[1]}\"";
    // getContent();
  }

  void initState() {
    super.initState();
    getContentV2();
  }

  // void initState() {
  //   super.initState();
  //   getContentV2();
  // }

  void getContentV2() async {
    print('inside getContent function');
    final messageString = await storageMethods.read("message");
    final List<dynamic> messages = jsonDecode(messageString);
    print(messages);
    print('test');
    setState(() {
      messageList = messages.map((e) => Message.fromJson(e)).toList();
    });
  }

  // Future<void> getContent() async {
  //   print('inside getContent function');
  //   preferences = await StreamingSharedPreferences.instance;
  //   content = preferences!.getString(keyName, defaultValue: "[]");
  // }

  String senderName = "Guan Feng";
  String receiverName = "";
  String keyName = "";

  StreamingSharedPreferences? preferences;
  Preference<String>? content;
  String initializedData = "[]";

  ChatStreamSocket chatStreamSocket = ChatStreamSocket();

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    connectAndListen(keyName, senderName);
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
                icon: const Icon(Icons.info))
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // chatMessages(),
              chatMessagesV2(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                        // sendMessage();
                        sendMessageV2(
                            messageController.text, receiverName, senderName);
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
        ));
  }

  // chatMessages() {
  //   return StreamBuilder(
  //     initialData: initializedData,
  //     stream: content,
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       if (snapshot.hasData) {
  //         dynamic messages = json.decode(snapshot.data);
  //         return ListView.builder(
  //           reverse: true,
  //           itemCount: messages.length,
  //           itemBuilder: (context, index) {
  //             int revIndex = messages.length - index - 1;
  //             MessageTile messageTile = MessageTile(
  //                 message: messages[revIndex]['message'],
  //                 sender: messages[revIndex]['sender'],
  //                 sentByMe: senderName == messages[revIndex]['sender']);
  //             // if last index give bottom padding
  //             if (index == 0) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 100),
  //                 child: messageTile,
  //               );
  //             }
  //             return messageTile;
  //           },
  //         );
  //       } else {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     },
  //   );
  // }

  // sendMessage() async {
  //   if (messageController.text.isNotEmpty) {
  //     Map<String, dynamic> chatMessageMap = {
  //       "message": messageController.text,
  //       "sender": senderName,
  //       "receiver": receiverName,
  //       "time": DateTime.now().millisecondsSinceEpoch,
  //     };

  //     dynamic oldContent = json.decode(content!.getValue());
  //     oldContent.add(chatMessageMap);
  //     String newContent = json.encode(oldContent);
  //     content!.setValue(newContent);
  //     print("new message sent");

  //     chatMessageMap.addAll({
  //       // sending message contents to socket server. Need room key.
  //       "room": keyName,
  //     });

  //     sendingMessage(chatMessageMap);
  //     setState(() {
  //       messageController.clear();
  //     });
  //   }
  // }

  chatMessagesV2() {
    return Expanded(
      child: GroupedListView(
        padding: const EdgeInsets.all(8),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        reverse: true,
        elements: messageList,
        groupBy: (message) => dateFormat.parse(message.dateTime),
        groupHeaderBuilder: (Message message) => SizedBox(
          height: 40,
          child: Center(
            child: Card(
              color: primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: const TextStyle(color: whiteColor),
                ),
              ),
            ),
          ),
        ),
        itemBuilder: (context, Message message) => Align(
          alignment:
              message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Card(
            color: primaryColor,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                message.text,
                style: const TextStyle(color: whiteColor, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendMessageV2(text, receiver, sender) async {
    final message = Message(
        text: text,
        receiver: receiver,
        sender: sender,
        dateTime: dateFormat.format(DateTime.now()),
        isSentByMe: true);

    setState(() {
      messageList.add(message);
    });
    String messageString = jsonEncode(messageList);
    storageMethods.write("message", messageString);
  }
}
