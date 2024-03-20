import 'package:flutter/material.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

class HomePageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return Container(
      child: Text("EUREKA"),
    );
  }
}
