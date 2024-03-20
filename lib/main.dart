import 'package:flutter/material.dart';
import 'package:pagepal/view/home/chat.dart';
import 'package:pagepal/view/home/home.dart';
import 'package:pagepal/view/home/profile.dart';
import 'package:pagepal/view/home/settings.dart';
import 'package:pagepal/view/home/shop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PagePal',
        initialRoute: 'swipe',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/chat':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ChatPageView(),
                transitionDuration: const Duration(seconds: 0),
                settings: settings,
              );
            case '/shop':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ShopPageView(),
                transitionDuration: const Duration(seconds: 0),
                settings: settings,
              );
            case '/profile':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ProfilePageView(),
                transitionDuration: const Duration(seconds: 0),
                settings: settings,
              );
            case '/swipe':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SwipePageView(),
                transitionDuration: const Duration(seconds: 0),
                settings: settings,
              );
            case '/settings':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SettingsPageView(),
                transitionDuration: const Duration(seconds: 0),
                settings: settings,
              );
          }
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SwipePageView(),
            transitionDuration: const Duration(seconds: 0),
            settings: settings,
          );
        });
  }
}
