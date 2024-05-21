import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/controller/nearby.dart';

class MainInfo extends StatefulWidget {
  const MainInfo({super.key});

  @override
  State<StatefulWidget> createState() => MainInfoState();
}

class MainInfoState extends State {
  final user = FirebaseAuth.instance.currentUser;

  String username = '';
  String userTitle = 'Scrum Master';
  String location = 'Porto, Portugal';

  @override
  void initState() {
    super.initState();
    updateUsername();
  }

  void updateUsername() async {
    final currentID = "/user/${FirebaseAuth.instance.currentUser?.uid}";
    final currentUser = await FirebaseFirestore.instance.doc(currentID).get();
    final newLocation = await getLocation(user!.email!);
    setState(() {
      username = currentUser.data()?["userName"] ?? 'No name';
      location = newLocation;
    });
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
                const Text(
                  "Current User",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
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
