import 'package:cloud_firestore/cloud_firestore.dart';

class BookExchange {
  final String book;
  final Timestamp date;
  final String giverID;
  final String takerID;

  BookExchange({
    required this.book,
    required this.date,
    required this.giverID,
    required this.takerID,
  });

  factory BookExchange.fromMap(Map<String, dynamic> map) {
    return BookExchange(
      book: map['book'],
      date: map['date'],
      giverID: map['giverID'],
      takerID: map['takerID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book': book,
      'date': date,
      'giverID': giverID,
      'takerID': takerID,
    };
  }
}
