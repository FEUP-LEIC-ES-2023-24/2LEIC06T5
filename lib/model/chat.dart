import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getRecievedMessages(String userID) async {
  final db = FirebaseFirestore.instance;
  final snapshot = await db.collection("message").where("recieverID", isEqualTo: userID).get();
  Map<String, dynamic> messages = {};

  snapshot.docs.forEach((doc) {
    messages[doc.id] = doc.data();
  });

  return messages;
}

Future<Map<String, dynamic>> getSentMessages(String userID) async {
  final db = FirebaseFirestore.instance;
  final snapshot = await db.collection("message").where("senderID", isEqualTo: userID).get();
  Map<String, dynamic> messages = {};

  snapshot.docs.forEach((doc) {
    messages[doc.id] = doc.data();
  });

  return messages;
}
