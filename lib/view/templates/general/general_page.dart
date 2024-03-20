import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pagepal/view/templates/general/widgets/bottom_nav_bar.dart';

abstract class GeneralPageState extends State {
  Widget getBody(BuildContext context);

  Widget build(BuildContext context) {
    return createBody(context, getBody(context));
  }

  Widget createBody(BuildContext context, Widget body) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: body,
    );
  }
}
