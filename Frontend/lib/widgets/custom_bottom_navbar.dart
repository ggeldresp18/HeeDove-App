import 'package:flutter/material.dart';
import '/home.dart';
import '/profile.dart';
import '/settings.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.blue,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 40),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 40),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, size: 40),
          label: '',
        ),
      ],
    );
  }
}
