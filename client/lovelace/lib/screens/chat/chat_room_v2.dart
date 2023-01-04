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
  TextEditingController messageController = TextEditingController();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd - kk:mm');

  List<Message> messages = [
    Message(
        text: 'heelo',
        date: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
        isSentByMe: false),
    Message(
        text: 'Lorem ipsum dolor sit amet',
        date: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
        isSentByMe: true),
    Message(
        text:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent neque lectus, vehicula Integer suscipit velit ac euismod dignissim.',
        date: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
        isSentByMe: true),
    Message(
        text:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent neque lectus, vehicula tempus mauris ac, imperdiet egestas felis. Morbi ultricies massa scelerisque tortor lacinia, iaculis posuere ante elementum. Proin a ultricies nisi. Aenean commodo semper metus at hendrerit. Vivamus tincidunt ex sapien, a tempus ligula fermentum pharetra. Phasellus id eros sit amet risus ultrices gravida. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec ut rutrum ligula. Integer suscipit velit ac euismod dignissim.',
        date: DateTime.now().subtract(
          const Duration(days: 2, minutes: 1),
        ),
        isSentByMe: false),
    Message(
        text:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent neque lectus, vehicula tempus mauris ac, imperdiet egestas felis. Morbi ultricies massa scelerisque tortor lacinia, iaculis posuere ante elementum. Proin a ultricies nisi. Aenean commodo semper metus at hendrerit. Vivamus tincidunt ex sapien, a tempus ligula fermentum pharetra. Phasellus id eros sit amet risus ultrices gravida. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec ut rutrum ligula. Integer suscipit velit ac euismod dignissim.',
        date: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
        isSentByMe: true),
    Message(
        text:
            'Lorem ipsum dolor sit amet, rerit. Vivamus titrices gravida. Vestibulum ante ipsum primis in faucibus orci luctus et ultrissim.',
        date: DateTime.now().subtract(
          const Duration(days: 3, minutes: 1),
        ),
        isSentByMe: false),
  ].reversed.toList();

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
        body: Column(
          children: <Widget>[
            Expanded(
                child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              elements: messages,
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              groupBy: (message) => DateTime(
                  message.date.year, message.date.month, message.date.day),
              groupHeaderBuilder: (Message message) => SizedBox(
                  height: 40,
                  child: Center(
                    child: Card(
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(DateFormat.yMMMd().format(message.date),
                              style: const TextStyle(color: whiteColor)),
                        )),
                  )),
              itemBuilder: (context, Message message) => Align(
                alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(message.text),
                    )),
              ),
            )),
            Container(
              color: messageBarColor,
              child: TextField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Enter a message'),
                onSubmitted: (text) {
                  final message = Message(
                      text: text, date: DateTime.now(), isSentByMe: true);
                  setState(() {
                    messages.add(message);
                  });
                },
              ),
            ),
          ],
        ));
  }
}
