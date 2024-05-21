import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainInfo extends StatefulWidget {
  const MainInfo({super.key});

  @override
  State<StatefulWidget> createState() => MainInfoState();
}

class MainInfoState extends State {
  final user = FirebaseAuth.instance.currentUser;

  String username = '';
  final String userTitle = 'Scrum Master';
  final String location = 'Porto, Portugal';

  @override
  void initState() {
    super.initState();
    username = user!.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  userTitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  location,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                )
              ],
            ),
          ),
        )),
      ],
    );
  }
}
