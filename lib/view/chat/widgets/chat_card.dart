import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/model/data/message.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final VoidCallback? onPressed;

  const MessageCard({
    Key? key,
    required this.message,
    this.onPressed,
  }) : super(key: key);

  Future<String> getUserName() async {
    final currentId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot<Map<String, dynamic>> user;
    if (currentId == message.senderID) {
      user = await FirebaseFirestore.instance.doc(message.senderID).get();
    } else {
      user = await FirebaseFirestore.instance.doc(message.recieverID).get();
    }
    return user["userName"];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width:
        MediaQuery
            .of(context)
            .size
            .width * 0.9, // 90% of the screen width
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Placeholder image, replace with actual image
                color: Colors.grey,
              ),
              child: Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            // Sender Name and Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "Loading...", // Placeholder text while loading
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                          "Error", // Placeholder text for error
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      }
                      return Text(
                        snapshot.data ?? "", // Display username if available
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  Text(
                    message.text,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            // Date
            Text(
              DateFormat('h:mm a').format(
                  message.date.toDate()), // You might want to format this date
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
