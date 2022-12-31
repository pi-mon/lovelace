class Message {
  final String text;
  final String date;
  final bool isSentByMe;

  Message({required this.text, required this.date, required this.isSentByMe});

  Message.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        date = json['date'],
        isSentByMe = json['isSentByMe'];

  Map<String, dynamic> toJson() =>
      {'text': text, 'date': date, 'isSentByMe': isSentByMe};

  @override
  String toString() => '($text, $date)';
}
