import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/controller/queries.dart';

class ChangeEmailDialog extends StatefulWidget {
  const ChangeEmailDialog({super.key});

  @override
  State<StatefulWidget> createState() => ChangeEmailDialogState();
}

class ChangeEmailDialogState extends State {
  final user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  String newEmail = '';

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
                        onSaved: (String? value) => newEmail = value!),
                  ),
                ],
              ))),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                user!.verifyBeforeUpdateEmail(newEmail);

                Navigator.of(context).pop();
              }
            },
            child: const Text("Change!"))
      ],
    );
  }
}
