import 'package:flutter/material.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class SwipePageView extends StatefulWidget {
  const SwipePageView({super.key});

  @override
  State<StatefulWidget> createState() => SwipePageViewState();
}

class SwipePageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("SWIPE PAGE")],
        ));
  }
}
