import 'package:flutter/material.dart';
import 'package:pagepal/view/profile/widgets/email_dialog.dart';
import 'package:pagepal/view/profile/widgets/image_picker.dart';
import 'package:pagepal/view/profile/widgets/password_dialog.dart';
import 'package:pagepal/view/profile/widgets/username_dialog.dart';

class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      backgroundColor: const Color(0xFFD4A373),
      content: IntrinsicHeight(
        child: Column(children: [
          const Text(
            "Change your Profile:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          buildButton(context, "Change Username", const ChangeUsernameDialog()),
          buildButton(context, "Change Password", const ChangePasswordDialog()),
          buildButton(context, "Change Email", const ChangeEmailDialog()),
          buildButton(context, "Change Avatar", const ImagePickerScreen()),
        ]),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Widget body) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            minimumSize: const Size(200, 40)),
        onPressed: () => {
              Navigator.of(context).pop(),
              showAdaptiveDialog(
                context: context,
                builder: (context) => body,
              ),
            },
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ));
  }
}
