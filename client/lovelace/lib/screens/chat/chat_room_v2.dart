import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lovelace/models/message.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/colors.dart';

class ChatRoomScreenV2 extends StatefulWidget {
  const ChatRoomScreenV2({super.key, required this.displayName});
  final String displayName;

  @override
  State<ChatRoomScreenV2> createState() => _ChatRoomScreenV2State();
}

class _ChatRoomScreenV2State extends State<ChatRoomScreenV2> {
  List<Message> messagesList = [];
  TextEditingController messageController = TextEditingController();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd - kk:mm');
  final StorageMethods _storageMethods = StorageMethods();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final String messageString = await _storageMethods.read("message");
    final List<dynamic> messages = jsonDecode(messageString);
    debugPrint('$messages');
    // debugPrint('${messages.last["text"]}');
    setState(() {
      messagesList = messages.map((e) => Message.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.displayName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: GroupedListView(
              padding: const EdgeInsets.all(8),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messagesList,
              groupBy: (message) => dateFormat.parse(message.date),
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
                alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(message.text),
                  ),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        hintText: "Type your message here..."),
                    onFieldSubmitted: (text) async {
                      final message = Message(
                          text: text,
                          date: dateFormat.format(DateTime.now()),
                          isSentByMe: true);
                      // debugPrint('$message'); // prints out as ('text', 'date')
                      setState(() {
                        messagesList.add(message);
                      });
                      String messageString = jsonEncode(messagesList);
                      _storageMethods.write("message", messageString);
                      _storageMethods.read("message");
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
