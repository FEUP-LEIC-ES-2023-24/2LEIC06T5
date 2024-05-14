import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pagepal/model/data/user.dart';
import 'package:pagepal/model/data/message.dart';

final db = FirebaseFirestore.instance;

Map<String, dynamic> findMostRecentMessage(List<Map<String, dynamic>> userMessages) {
  Timestamp? mostRecentTimestamp;
  Map<String, dynamic>? mostRecentMessage;

  for (Map<String, dynamic> message in userMessages) {
    Timestamp messageTimestamp = message['date'] as Timestamp;

    if (mostRecentTimestamp == null || messageTimestamp.compareTo(mostRecentTimestamp) > 0) {
      mostRecentTimestamp = messageTimestamp;
      mostRecentMessage = message;
    }
  }

  return mostRecentMessage ?? {}; // Return an empty map if no messages are found
}

Future<List<Message>> getRecievedMessages(String userID) async {
  final snapshot = await db.collection("message").where(
      Filter.and(Filter('recieverID', isEqualTo: "/user/${FirebaseAuth.instance.currentUser!.uid}"), Filter('senderID', isEqualTo: userID))).get();
  List<Message> messages = [];

  snapshot.docs.forEach((doc) {
    messages.add(Message.fromMap(doc.data()));
  });

  return messages;
}

Future<List<Message>> getSentMessages(String userID) async {
  final snapshot = await db.collection("message").where(
    Filter.and(Filter('senderID', isEqualTo: "/user/${FirebaseAuth.instance.currentUser!.uid}"), Filter('recieverID', isEqualTo: userID))).get();
  List<Message> messages = [];

  snapshot.docs.forEach((doc) {
    messages.add(Message.fromMap(doc.data()));
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

  for (final doc in snapshot.docs) {
    String senderRef = doc["senderID"];
    String recieverRef = doc["recieverID"];

    if (senderRef == userID) {
      final userSnap = await db.doc(recieverRef).get();
      users.add("/${userSnap.reference.path}");
    } else {
      final userSnap = await db.doc(senderRef).get();
      users.add("/${userSnap.reference.path}");
    }
  }
  return users;
}

Future<List<Message>> getMostRecentMessagesOfUser(String userID) async {
  List<Message> messages = [];

  final users = await getAllUsersChattedWith(userID);

  for (final user in users) {
    List<Map<String, dynamic>> userMessages = [];

    final snapshot = await db.collection('message').where(
      Filter.or(
          Filter.and(Filter("senderID", isEqualTo: userID), Filter("recieverID", isEqualTo: user)),
          Filter.and(Filter("recieverID", isEqualTo: userID), Filter("senderID", isEqualTo: user)))
    ).get();


    for (final message in snapshot.docs) {
      userMessages.add(message.data());
    }
    messages.add(Message.fromMap(findMostRecentMessage(userMessages)));
  }

  return messages;
}

Future<List<Message>> getAllMessagesByhUserOrdered(String userID) async {
  List<Message> sentMessages = await getSentMessages("/$userID");
  List<Message> recievedMessages = await getRecievedMessages("/$userID");

  List<Message> messages = [];

  for (final message in sentMessages) {
    messages.add(message);
  }

  for (final message in recievedMessages) {
    messages.add(message);
  }

  messages.sort((a,b) => b.date.compareTo(a.date));

  return messages;
}

bool sendMessage(Message message) {
  try {
    db.collection("message").add(message.toMap());
    return true;
  } catch (error) {
    print(error.toString());
    return false;
  }
}
