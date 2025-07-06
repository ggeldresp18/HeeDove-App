import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navbar.dart';

class DetImagePage extends StatelessWidget {
  const DetImagePage({Key? key}) : super(key: key);

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

            // Ícono de la cámara del smartphone
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Icon(
                Icons.phone_android,
                size: 100,
                color: Colors.grey[800],
              ),
            ),

            // Título
            const SizedBox(height: 20),
            const Text(
              'Reconocimiento de\nimágenes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const Spacer(),

            // Botón circular de Play con cámara
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraViewPage(),
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
                      Icon(Icons.camera_alt, size: 50, color: Colors.white),
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

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key? key}) : super(key: key);

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  bool cameraOn = true;
  String? diagnosisText;

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
                  'Detección de Imágenes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Área del smartphone
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Ícono del smartphone
                    Icon(
                      Icons.phone_android,
                      size: 48,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(height: 20),
                    // Área de visualización de la cámara
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: cameraOn
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: const ColoredBox(color: Colors.black87),
                              )
                            : Center(
                                child: Text(
                                  'No disponible',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Área de diagnóstico
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        diagnosisText ?? 'Diagnóstico: -',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),

                    // Botones circulares
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _CircularButton(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.pop(context),
                            size: 65,
                          ),
                          _CircularButton(
                            icon: cameraOn
                                ? Icons.videocam
                                : Icons.videocam_off,
                            onTap: () {
                              setState(() {
                                cameraOn = !cameraOn;
                              });
                            },
                            size: 65,
                          ),
                          _CircularButton(
                            icon: Icons.camera_alt,
                            backgroundColor: const Color(0xFF20B2AA),
                            iconColor: Colors.white,
                            size: 75,
                            onTap: () {
                              if (cameraOn) {
                                setState(() {
                                  diagnosisText =
                                      'Diagnóstico: Carro rojo estacionado al lado de una casa beige';
                                });
                              }
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

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const _CircularButton({
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
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
        child: Icon(
          icon,
          color: iconColor ?? Colors.grey[800],
          size: size * 0.5,
        ),
      ),
    );
  }
}
