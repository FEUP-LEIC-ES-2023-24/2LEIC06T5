import 'package:flutter/material.dart';
import 'package:pagepal/model/nav_item.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum NavBarItem {
  messagesItem(
    Icon(
      PhosphorIconsBold.chatCircle,
      color: Colors.white,
      size: 30,
    ),
    NavItem.messagesPage,
  ),
  swipeItem(
      Icon(
        PhosphorIconsBold.books,
        color: Colors.white,
        size: 30,
      ),
      NavItem.swipePage),
  profileItem(
    Icon(
      PhosphorIconsBold.user,
      color: Colors.white,
      size: 30,
    ),
    NavItem.profilePage,
  );

  const NavBarItem(this.icon, this.page);

  final Icon icon;
  final NavItem page;
}
