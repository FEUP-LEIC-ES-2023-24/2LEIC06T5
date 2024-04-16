import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/model/data/message.dart';
import 'package:pagepal/view/chat/widgets/chat_card.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

void doNothing() {
  print('hi');
}

class ChatPageView extends StatefulWidget {
  const ChatPageView({super.key});

  @override
  State<StatefulWidget> createState() => ChatPageViewState();
}

class ChatPageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        MessageCard(message: Message(senderID: "John", recieverID: "Doe", text: "Hullo", date: Timestamp.now(), isRead: false), onPressed: doNothing)
      ],
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 55, right: 25),
          child: Text(
            "Messages",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Color(0xFFCCD5AE),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300], // Grey background color
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10), // Reduced padding
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10), // Margin to adjust size
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search), // Search icon
              SizedBox(width: 10), // Spacer between icon and TextField
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    border: InputBorder.none, // Remove border around TextField
                  ),
                  onChanged: (value) {
                    // Implement search functionality
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
