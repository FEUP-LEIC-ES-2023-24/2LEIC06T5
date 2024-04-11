import 'package:flutter/material.dart';
import 'package:pagepal/view/chat/chat.dart';
import 'package:pagepal/view/swipe/swipe.dart';
import 'package:pagepal/view/profile/profile.dart';
import 'package:pagepal/view/settings/settings.dart';
import 'package:pagepal/view/shop/shop.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
