import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget? currentSubpage;

  @override
  Widget build(BuildContext context) {
    if (currentSubpage != null) {
      return currentSubpage!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: const Color(0xFF278B1C),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ajustes',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // Preferencias de la cuenta
                _SettingsOption(
                  icon: Icons.person_outline,
                  title: 'Preferencias de la cuenta',
                  onTap: () {
                    setState(() {
                      currentSubpage = _AccountPreferencesPage(
                        onBack: () => setState(() => currentSubpage = null),
                      );
                    });
                  },
                ),

                // Inicio de sesión y seguridad
                _SettingsOption(
                  icon: Icons.lock_outline,
                  title: 'Inicio de sesión y\nseguridad',
                  onTap: () {
                    setState(() {
                      currentSubpage = _SecurityPage(
                        onBack: () => setState(() => currentSubpage = null),
                      );
                    });
                  },
                ),

                // Notificaciones
                _SettingsOption(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notificaciones',
                  onTap: () {
                    setState(() {
                      currentSubpage = _NotificationsPage(
                        onBack: () => setState(() => currentSubpage = null),
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          // Cerrar sesión y versión en la esquina inferior izquierda
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    // Implementar lógica de cierre de sesión
                  },
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'VERSIÓN: X.X.XXXX.X',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}

// Página de Preferencias de la cuenta
class _AccountPreferencesPage extends StatelessWidget {
  final VoidCallback onBack;

  const _AccountPreferencesPage({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Preferencias de la cuenta'),
        backgroundColor: const Color(0xFF278B1C),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PreferenceOption(title: 'Idioma', subtitle: 'Español', onTap: () {}),
          _PreferenceOption(title: 'Tema', subtitle: 'Claro', onTap: () {}),
          _PreferenceOption(
            title: 'Tamaño de fuente',
            subtitle: 'Normal',
            onTap: () {},
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}

// Página de Seguridad
class _SecurityPage extends StatelessWidget {
  final VoidCallback onBack;

  const _SecurityPage({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Seguridad'),
        backgroundColor: const Color(0xFF278B1C),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PreferenceOption(title: 'Cambiar contraseña', onTap: () {}),
          _PreferenceOption(
            title: 'Autenticación de dos factores',
            subtitle: 'Desactivado',
            onTap: () {},
          ),
          _PreferenceOption(title: 'Dispositivos conectados', onTap: () {}),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}

// Página de Notificaciones
class _NotificationsPage extends StatelessWidget {
  final VoidCallback onBack;

  const _NotificationsPage({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: const Color(0xFF278B1C),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _NotificationOption(
            title: 'Mensajes',
            isEnabled: true,
            onChanged: (value) {},
          ),
          _NotificationOption(
            title: 'Sonidos',
            isEnabled: true,
            onChanged: (value) {},
          ),
          _NotificationOption(
            title: 'Vibraciones',
            isEnabled: false,
            onChanged: (value) {},
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}

// Widgets auxiliares
class _SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferenceOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _PreferenceOption({
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _NotificationOption extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const _NotificationOption({
    required this.title,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: isEnabled,
      onChanged: onChanged,
      activeColor: const Color(0xFF278B1C),
    );
  }
}
