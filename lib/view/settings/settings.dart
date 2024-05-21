import 'package:flutter/material.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({super.key});

  @override
  State<StatefulWidget> createState() => SettingsPageViewState();
}

class SettingsPageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("SETTINGS PAGE")],
        ));
  }

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return null;
  }
}
