import 'package:flutter/material.dart';
import 'package:pagepal/model/nav_item.dart';

enum NavBarItem {
  shopItem(
    Icons.storefront,
    NavItem.shopPage,
  ),
  messagesItem(
    Icons.markunread,
    NavItem.messagesPage,
  ),
  swipeItem(
    Icons.auto_stories,
    NavItem.swipePage,
  ),
  profileItem(
    Icons.person,
    NavItem.profilePage,
  ),
  settingsItem(
    Icons.settings,
    NavItem.settingsPage,
  );

  const NavBarItem(this.icon, this.page);

  final IconData icon;
  final NavItem page;
}
