import 'package:flutter/material.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class ChatPageView extends StatefulWidget {
  const ChatPageView({super.key});

  @override
  State<StatefulWidget> createState() => ChatPageViewState();
}

class ChatPageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("CHAT PAGE")],
        ));
  }

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return null;
  }
}
