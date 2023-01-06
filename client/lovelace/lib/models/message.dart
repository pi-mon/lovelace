class Message {
  final String message;
  final String sender;
  final String receiver;
  final DateTime dateTime;

  Message(
      {required this.message,
      required this.sender,
      required this.receiver,
      required this.dateTime});

  Message.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        sender = json['sender'],
        receiver = json['receiver'],
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() => {
        'message': message,
        'sender': sender,
        'receiver': receiver,
        'dateTime': dateTime.toIso8601String(),
      };

  // @override
  // String toString() => '($text, $date)';
}
