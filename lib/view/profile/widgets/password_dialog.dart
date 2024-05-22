import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<StatefulWidget> createState() => ChangePasswordDialogState();
}

class ChangePasswordDialogState extends State {
  final user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  String newPassword = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      content: IntrinsicHeight(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("New password"),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                        onSaved: (String? value) => newPassword = value!),
                  ),
                ],
              ))),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                user!.updatePassword(newPassword);

                Navigator.of(context).pop();
              }
            },
            child: const Text("Change!"))
      ],
    );
  }
}
