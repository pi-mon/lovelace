import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/screens/chat/chat_room_screen.dart';
import 'package:lovelace/utils/colors.dart';

class ChatPerson extends StatelessWidget {
  final UserDetails userDetails;
  final DateTime time;
  const ChatPerson({
    super.key,
    required this.userDetails,
    required this.time,
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
                    builder: (context) => ChatRoomScreen(
                          receiverEmail: userDetails.email,
                        )));
          },
          style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/images/default-profile-picture.png')),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    border:
                        Border.all(width: .5, color: Colors.grey.shade300), // ]
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(userDetails.displayName,
                          style: const TextStyle(color: blackColor)),
                      Text(timeString,
                          style: const TextStyle(color: blackColor))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
