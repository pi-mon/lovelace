class Message {
  final String text;
  final String sender;
  final String receiver;
  final String dateTime;

  Message(
      {required this.text,
      required this.sender,
      required this.receiver,
      required this.dateTime});

  Message.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        sender = json['sender'],
        receiver = json['receiver'],
        dateTime = json['dateTime'];

  Map<String, dynamic> toJson() => {
        'text': text,
        'sender': sender,
        'receiver': receiver,
        'dateTime': dateTime,
      };

  // @override
  // String toString() => '($text, $date)';
}
