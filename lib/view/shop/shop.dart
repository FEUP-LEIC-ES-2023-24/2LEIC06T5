import 'package:flutter/material.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class ShopPageView extends StatefulWidget {
  const ShopPageView({super.key});

  @override
  State<StatefulWidget> createState() => ShopPageViewState();
}

class ShopPageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return const SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("SHOP PAGE")],
        ));
  }
}
