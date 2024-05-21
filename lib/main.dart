import 'package:flutter/material.dart';
import 'package:pagepal/controller/auth/auth_gate.dart';
import 'package:pagepal/view/chat/chat.dart';
import 'package:pagepal/view/chat/widgets/individual_chat.dart';
import 'package:pagepal/view/swipe/swipe.dart';
import 'package:pagepal/view/profile/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        initialRoute: '/auth',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/auth':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const AuthGate(),
                transitionDuration: const Duration(seconds: 0),
                settings: settings,
              );
            case '/chat':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ChatPageView(),
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
            case '/individual_chat':
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const IndividualChatView(),
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
