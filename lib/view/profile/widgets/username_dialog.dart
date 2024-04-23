import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/controller/queries.dart';

class ChangeUsernameDialog extends StatefulWidget {
  const ChangeUsernameDialog({super.key});

  @override
  State<StatefulWidget> createState() => ChangeUsernameDialogState();
}

class ChangeUsernameDialogState extends State {
  final user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  String newUsername = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      content: IntrinsicHeight(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                        onSaved: (String? value) => newUsername = value!),
                  ),
                ],
              ))),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                user!.updateDisplayName(newUsername);

                QuerySnapshot userQuery =
                    await Queries.getUser(user!.email ?? '');

                userQuery.docs.first.reference
                    .update({'userName': newUsername});

                Navigator.of(context).pop();
              }
            },
            child: const Text("Change!"))
      ],
    );
  }
}
