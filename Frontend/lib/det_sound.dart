import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navbar.dart';

class DetSoundPage extends StatelessWidget {
  const DetSoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sección superior con degradado y bordes redondeados
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF40E0D0), // Turquesa más claro
                    Color(0xFF20B2AA), // Turquesa medio
                  ],
                  stops: [0.0, 0.8],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),

            // Ícono de auriculares
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Icon(Icons.headphones, size: 100, color: Colors.grey[800]),
            ),

            // Título
            const SizedBox(height: 20),
            const Text(
              'Reconocimiento de\nsonidos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const Spacer(),

            // Botón circular de Play
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SoundListenPage(),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF20B2AA),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Play',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: -1),
    );
  }
}

class SoundListenPage extends StatefulWidget {
  const SoundListenPage({Key? key}) : super(key: key);

  @override
  State<SoundListenPage> createState() => _SoundListenPageState();
}

class _SoundListenPageState extends State<SoundListenPage> {
  List<SoundItem> detectedSounds = [];
  bool isListening = true;

  @override
  void initState() {
    super.initState();
    // Simular la detección de sonidos
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          detectedSounds.add(
            SoundItem(
              icon: Icons.car_repair,
              label: 'Bocina de auto',
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          detectedSounds.add(
            SoundItem(
              icon: Icons.notifications_active,
              label: 'Timbre',
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          detectedSounds.add(
            SoundItem(
              icon: Icons.pets,
              label: 'Ladrido de perro',
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header con degradado y bordes redondeados
            Container(
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF40E0D0), Color(0xFF20B2AA)],
                  stops: [0.0, 0.8],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Center(
                child: Text(
                  'Detección de Sonidos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    // Lista de sonidos detectados
                    Expanded(
                      child: ListView.builder(
                        itemCount: detectedSounds.length,
                        itemBuilder: (context, index) {
                          final sound = detectedSounds[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF20B2AA).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF20B2AA,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  sound.icon,
                                  color: const Color(0xFF20B2AA),
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                sound.label,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Botones de control
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _CircularButton(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.pop(context),
                          ),
                          _CircularButton(
                            icon: Icons.pause,
                            onTap: () {
                              setState(() {
                                isListening = !isListening;
                              });
                            },
                            backgroundColor: const Color(0xFF20B2AA),
                            iconColor: Colors.white,
                          ),
                          _CircularButton(
                            icon: Icons.delete,
                            onTap: () {
                              setState(() {
                                detectedSounds.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: -1),
    );
  }
}

class SoundItem {
  final IconData icon;
  final String label;
  final DateTime timestamp;

  SoundItem({required this.icon, required this.label, required this.timestamp});
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const _CircularButton({
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? Colors.grey[800], size: 30),
      ),
    );
  }
}
