import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Discover'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_off_outlined), label: 'Profile'),
      ],
    );
  }
}
