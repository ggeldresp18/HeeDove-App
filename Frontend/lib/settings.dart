import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'widgets/custom_bottom_navbar.dart'; 

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(0xFF278B1C),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Lógica para notificaciones
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Lógica para cambiar idioma
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('Soporte'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Lógica para soporte
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de HeeDove'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Lógica para info
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2), // 👈 Barra común
    );
  }
}
