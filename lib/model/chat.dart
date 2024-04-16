import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

Future<Map<String, dynamic>> getRecievedMessages(String userID) async {
  final snapshot = await db.collection("message").where("recieverID", isEqualTo: userID).get();
  Map<String, dynamic> messages = {};

  snapshot.docs.forEach((doc) {
    messages[doc.id] = doc.data();
  });

  return messages;
}

Future<Map<String, dynamic>> getSentMessages(String userID) async {
  final snapshot = await db.collection("message").where("senderID", isEqualTo: userID).get();
  Map<String, dynamic> messages = {};

  snapshot.docs.forEach((doc) {
    messages[doc.id] = doc.data();
  });

  return messages;
}

Future<Set<String>> getAllUsersChattedWith(String userID) async {
  final snapshot = await db.collection("message").where(
    Filter.or(
      Filter("senderID", isEqualTo: userID),
      Filter("recieverID", isEqualTo: userID)
    )
  ).get();

  Set<String> users = {};

  snapshot.docs.forEach((doc) {
    String sender = doc["senderID"];
    String reciever = doc["recieverID"];

    if (sender != userID) {
      users.add(sender);
    } else if (reciever != userID) {
      users.add(reciever);
    }
  });

  return users;
}
