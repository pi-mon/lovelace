import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lovelace/models/message.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/utils/colors.dart';

class ChatRoomScreenV2 extends StatefulWidget {
  const ChatRoomScreenV2({super.key});

  @override
  State<ChatRoomScreenV2> createState() => _ChatRoomScreenV2State();
}

class _ChatRoomScreenV2State extends State<ChatRoomScreenV2> {
  List<Message> messagesList = [];
  TextEditingController messageController = TextEditingController();
  final StorageMethods _storageMethods = StorageMethods();
  final _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());
  String filePath = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final List<dynamic> messages = await _storageMethods.read("message");
    debugPrint('$messages');
    setState(() {
      messagesList = messages.map((e) => Message.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sarah",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              groupBy: (message) => DateTime.parse(message.date),
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
                      final timeSent = DateTime.now();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd - kk:mm').format(timeSent);
                      final message = Message(
                          text: text, date: formattedDate, isSentByMe: true);
                      // debugPrint('$message'); // prints out as ('text', 'date')
                      setState(() {
                        messagesList.add(message);
                      });
                      // TODO: WRITE MESSAGE TO LOCAL STORAGE & GET IT
                      _storageMethods.write("message", messagesList);
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
