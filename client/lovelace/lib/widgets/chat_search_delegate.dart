import 'package:flutter/material.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/screens/chat/chat_room_screen.dart';
import 'package:lovelace/utils/colors.dart';

class ChatSearchDelegate extends SearchDelegate {
  final List<UserDetails> userDetailsList;
  ChatSearchDelegate(this.userDetailsList);

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null); // close search bar and go back to previous screen
      },
      icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                // close search bar is input field is empty
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(query,
            style: const TextStyle(fontSize: 16, color: blackColor)),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<UserDetails> userDetailsListSearched = userDetailsList.where((value) {
      String searchResult = value.displayName;
      String result = searchResult.toLowerCase();
      String input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: userDetailsListSearched.length,
      itemBuilder: (context, index) {
        UserDetails userDetails = userDetailsListSearched[index];
        return ListTile(
          title: Text(userDetails.displayName),
          onTap: () {
            query = userDetails.displayName;
            print(query);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatRoomScreen(
                          receiverEmail: query,
                        )));
          },
        );
      },
    );
  }
}
