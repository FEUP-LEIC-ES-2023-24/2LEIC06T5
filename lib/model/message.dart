import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pagepal/model/data/user.dart';
import 'package:pagepal/model/data/message.dart';

final db = FirebaseFirestore.instance;

Future<List<Message>> getRecievedMessages(String userID) async {
  final snapshot = await db
      .collection("message")
      .where("recieverID", isEqualTo: userID)
      .get();
  List<Message> messages = [];

  snapshot.docs.forEach((doc) {
    messages.add(Message.fromMap(doc.data()));
  });

  return messages;
}

Future<List<Message>> getSentMessages(String userID) async {
  final snapshot =
      await db.collection("message").where("senderID", isEqualTo: userID).get();
  List<Message> messages = [];

  snapshot.docs.forEach((doc) {
    messages.add(Message.fromMap(doc.data()));
  });

  return messages;
}

Future<List<User>> getAllUsersChattedWith(String userID) async {
  final snapshot = await db
      .collection("message")
      .where(Filter.or(Filter("senderID", isEqualTo: userID),
          Filter("recieverID", isEqualTo: userID)))
      .get();

  List<User> users = [];

  for (final doc in snapshot.docs) {
    String sender = doc["senderID"];
    String reciever = doc["recieverID"];

    if (sender != userID) {
      final userSnap = await db.collection('user').doc(sender).get();
      Map<String, dynamic>? map = userSnap.data();
      if (map != null) {
        users.add(User.fromMap(map));
      }
    } else if (reciever != userID) {
      final userSnap = await db.collection('user').doc(reciever).get();
      Map<String, dynamic>? map = userSnap.data();
      if (map != null) {
        users.add(User.fromMap(map));
      }
    }
  }
  return users;
}
