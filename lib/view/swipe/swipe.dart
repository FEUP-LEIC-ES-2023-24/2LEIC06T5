import 'package:flutter/material.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

import '../../model/slide_card.dart';

class SwipePageView extends StatefulWidget {
  const SwipePageView({super.key});

  @override
  State<StatefulWidget> createState() => SwipePageViewState();
}

class SwipePageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return SlideCard();
  }
}
