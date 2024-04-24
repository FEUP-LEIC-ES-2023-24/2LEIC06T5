import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/view/swipe/swipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
              providers: [
                EmailAuthProvider(),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset('assets/dune.jpg'),
                    ));
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: action == AuthAction.signIn
                      ? const Text("Welcome to PagePal, please sign in!")
                      : const Text("Welcome to PagePal, please sign up!"),
                );
              },
              footerBuilder: (context, action) {
                return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      "By signing in, you agree to our terms and conditions.",
                      style: TextStyle(color: Colors.grey),
                    ));
              });
        }

        _addUserToFirestore(snapshot.data!);

        return const SwipePageView();
      },
    );
  }

  void _addUserToFirestore(User user) {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('user');
    usersRef.doc(user.uid).set({
      'email': user.email,
      'likedGenres': [],
      'owns': [],
      'Location': const GeoPoint(0, 0),
      'userName': '',
    });
  }
}
