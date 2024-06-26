import 'package:flutter/material.dart';
import 'package:pagepal/model/navbar_item.dart';
import 'package:pagepal/model/nav_item.dart';
import 'package:pagepal/view/templates/general/widgets/bottom_nav_bar.dart';

abstract class GeneralPageState extends State {
  Widget getBody(BuildContext context);
  PreferredSizeWidget? getAppBar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return createBody(context, getBody(context), getAppBar(context));
  }

  Widget createBody(
      BuildContext context, Widget body, PreferredSizeWidget? appBar) {
    return SafeArea(
        child: Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4A373),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => Navigator.pushNamed(context, NavItem.swipePage.page),
        child: NavBarItem.swipeItem.icon,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
      body: body,
    ));
  }
}
