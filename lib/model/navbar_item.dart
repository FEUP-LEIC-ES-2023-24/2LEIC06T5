import 'package:flutter/material.dart';
import 'package:pagepal/model/nav_item.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum NavBarItem {
  shopItem(
    Icon(PhosphorIconsBold.shoppingCart, color: Colors.white, size: 30),
    NavItem.shopPage,
  ),
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
  ),
  settingsItem(
    Icon(
      PhosphorIconsBold.gear,
      color: Colors.white,
      size: 30,
    ),
    NavItem.settingsPage,
  );

  const NavBarItem(this.icon, this.page);

  final Icon icon;
  final NavItem page;
}
