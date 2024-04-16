import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String recieverID;
  final String text;
  final Timestamp date;

  Message({
    required this.senderID,
    required this.recieverID,
    required this.text,
    required this.date
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderID: map['senderID'],
      recieverID: map['recieverID'],
      text: map['text'],
      date: map['date']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID' : senderID,
      'recieverID' : recieverID,
      'text' : text,
      'date' : date
    };
  }
}