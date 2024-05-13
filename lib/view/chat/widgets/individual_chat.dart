import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/model/message.dart';
import 'package:pagepal/view/chat/widgets/message_card.dart';

import '../../../model/data/message.dart';

class IndividualChatView extends StatefulWidget {
  const IndividualChatView({super.key});

  @override
  State<StatefulWidget> createState() => IndividualChatViewState();
}

class IndividualChatViewState extends State<IndividualChatView> {
  final messageController = TextEditingController();
  String messager = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> getUserName() async {
    final message = ModalRoute.of(context)?.settings.arguments as Message;
    final currentId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot<Map<String, dynamic>> user;
    if (currentId == message.senderID) {
      user = await FirebaseFirestore.instance.doc(message.senderID).get();
    } else {
      user = await FirebaseFirestore.instance.doc(message.recieverID).get();
    }
    setState(() {
      messager = user["userName"];
    });
  }

  Future<String> getRecieverId() async {
    final message = ModalRoute.of(context)?.settings.arguments as Message;
    final currentId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot<Map<String, dynamic>> user;
    if (currentId == message.senderID) {
      user = await FirebaseFirestore.instance.doc(message.senderID).get();
    } else {
      user = await FirebaseFirestore.instance.doc(message.recieverID).get();
    }
    return user.id;
  }

  Future pressSendButton(BuildContext context) async {
    final senderID = FirebaseAuth.instance.currentUser!.uid;
    final recieverID = await getRecieverId();
    final message = Message(senderID: senderID, recieverID: recieverID,
        text: messageController.text, date: Timestamp.now(), isRead: false);
    sendMessage(message);
  }

  Widget? uploadFile() {
    setState(() {
      messages.insert(
          0,
          SingleMessageCard(
              'akshdvatusfdtyafwkudyafsksurdfLIYDGLAIYGDLIUAYGSFIYLSGDFLIYSGDLUFVSDLUFSVDLFYGSDIYFGAEWIUDHALISYDGAIDGWAUWHDAIYWGD',
              Random().nextBool()));
    });
    return null;
  }

  Widget? sendPicture() {
    return null;
  }

  final List<SingleMessageCard> messages = [];

  @override
  Widget build(BuildContext context) {
    getUserName();
    return Scaffold(
        body: Column(
      children: [
        AppBar(
          title: Text(messager),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                reverse: true,
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 20, bottom: 20),
                itemBuilder: (context, index) {
                  return Align(
                    alignment: (messages[index].isUserMessage
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (messages[index].isUserMessage
                              ? const Color(0xFFCCD5AE)
                              : const Color(0xFFD1CBCB))),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(5),
                      child: Text(messages[index].message,
                          style: const TextStyle(fontSize: 15)),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFCCD5AE),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => uploadFile(), icon: const Icon(Icons.add)),
              IconButton(
                  onPressed: () => sendPicture(),
                  icon: const Icon(Icons.image)),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: "Message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => pressSendButton(context),
                icon: const Icon(Icons.send),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
