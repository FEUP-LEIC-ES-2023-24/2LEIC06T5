import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String recieverID;
  final String text;
  final Timestamp time;

  Message({
    required this.senderID,
    required this.recieverID,
    required this.text,
    required this.time
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderID: map['senderID'],
      recieverID: map['recieverID'],
      text: map['text'],
      time: map['time']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID' : senderID,
      'recieverID' : recieverID,
      'text' : text,
      'time' : time
    };
  }
}