enum NavItem {
  swipePage('swipe'),
  profilePage('profile'),
  messagesPage('chat'),
  settingsPage('settings'),
  shopPage('shop');

  const NavItem(this.page);

  final String page;
}
