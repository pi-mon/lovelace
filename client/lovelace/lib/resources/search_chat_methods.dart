import 'package:flutter/material.dart';
import 'package:lovelace/screens/chat/chat_room_screen.dart';
import 'package:lovelace/utils/colors.dart';

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    'Sarah',
    'John',
    'Adam',
    'Tom',
    'Ryan'
  ]; // contain the list of contacts the user has chats with
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
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
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
