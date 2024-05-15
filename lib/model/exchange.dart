import 'package:cloud_firestore/cloud_firestore.dart';

class Exchange {
  Exchange ({
    required this.user1,
    required this.user2,
    required this.book1,
    required this.book2
  });

  final DocumentReference user1;
  final DocumentReference user2;
  final DocumentReference book1;
  final DocumentReference book2;
}