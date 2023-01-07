class Message {
  final String text;
  final String sender;
  final String receiver;
  final String dateTime;
  final bool isSentByMe;

  Message(
      {required this.text,
      required this.sender,
      required this.receiver,
      required this.dateTime,
      required this.isSentByMe});

  Message.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        sender = json['sender'],
        receiver = json['receiver'],
        dateTime = json['dateTime'],
        isSentByMe = json['isSentByMe'];

  Map<String, dynamic> toJson() => {
        'text': text,
        'sender': sender,
        'receiver': receiver,
        'dateTime': dateTime,
        'isSentByMe': isSentByMe
      };

  // @override
  // String toString() => '($text, $date)';
}
