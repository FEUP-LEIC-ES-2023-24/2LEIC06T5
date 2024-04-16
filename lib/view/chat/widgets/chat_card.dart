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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 90% of the screen width
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
                  Text(
                    message.senderID,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
              DateFormat('h:mm a').format(message.date.toDate()),// You might want to format this date
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}