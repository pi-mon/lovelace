import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lovelace/screens/chat/chat_room_v2.dart';
import 'package:lovelace/utils/colors.dart';

class ChatPerson extends StatelessWidget {
  final DateTime time;
  final String name;
  const ChatPerson({
    super.key,
    required this.time,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('jm');
    final String timeString = formatter.format(time);
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatRoomScreenV2(
                          displayName: name,
                        )));
          },
          style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(width: 2, color: primaryColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ]),
                    child: const Icon(Icons.person, size: 40)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(name, style: const TextStyle(color: blackColor)),
                      Text(timeString,
                          style: const TextStyle(color: blackColor))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 1),
      ],
    );
  }
}
