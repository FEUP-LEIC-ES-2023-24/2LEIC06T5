class Feedback {
  final String exchange;
  final String giverUserID;
  final int num;
  final String recieverUserID;
  final String text;

  Feedback({
    required this.exchange,
    required this.giverUserID,
    required this.num,
    required this.recieverUserID,
    required this.text,
  });

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      exchange: map['exchange'],
      giverUserID: map['giverUserID'],
      num: map['num'],
      recieverUserID: map['recieverUserID'],
      text: map['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exchange': exchange,
      'giverUserID': giverUserID,
      'num': num,
      'recieverUserID': recieverUserID,
      'text': text,
    };
  }
}
