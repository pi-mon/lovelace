import 'package:flutter/material.dart';
import 'package:lovelace/screens/chat/chat_room.dart';
import 'package:lovelace/utils/colors.dart';

class ContactItem extends StatelessWidget {
  final String time;
  final String contact;
  final String lastText;
  const ContactItem(
      {super.key,
      required this.time,
      required this.contact,
      required this.lastText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: REDIRECT TO CHAT ROOM PAGE
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatRoomScreen()));
      },
      child: Row(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
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
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(contact, style: const TextStyle(color: blackColor)),
                    Text(time.toString(),
                        style: const TextStyle(color: blackColor))
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  lastText,
                  style: const TextStyle(color: blackColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
