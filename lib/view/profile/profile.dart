import 'package:flutter/material.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

class ProfilePageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("PROFILE PAGE")],
        ));
  }
}
