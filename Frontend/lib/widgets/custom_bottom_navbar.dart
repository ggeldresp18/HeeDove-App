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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Aseguramos que currentIndex sea 0, 1, o 2
    final safeIndex = (currentIndex >= 0 && currentIndex <= 2)
        ? currentIndex
        : 0;

    return BottomNavigationBar(
      currentIndex: safeIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: currentIndex < 0
          ? Colors.white
          : Colors.green, // Si currentIndex es negativo, nada se marca
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.blue,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 40), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person, size: 40), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, size: 40),
          label: '',
        ),
      ],
    );
  }
}
