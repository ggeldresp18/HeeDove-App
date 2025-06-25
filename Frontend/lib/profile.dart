import 'package:flutter/material.dart';
import 'home.dart';
import 'settings.dart';
import 'widgets/custom_bottom_navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF278B1C),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Usuario040325',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'usuario@heedove.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Cambiar contraseña'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Acción para cambiar contraseña
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Acción de logout
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1), // 👈 Barra reutilizable
    );
  }
}
