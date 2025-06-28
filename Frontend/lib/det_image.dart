import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navbar.dart';

class DetImagePage extends StatelessWidget {
  const DetImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0CA3C3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 24),
            width: double.infinity,
            child: const Text(
              'Detección de imágenes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraViewPage()),
                );
              },
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF278B1C),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'Ready',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
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
  // Aquí iría la lógica real de la cámara

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0CA3C3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 24),
            width: double.infinity,
            child: const Text(
              'Detección de imágenes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: Center(
              child: Icon(
                cameraOn ? Icons.videocam : Icons.videocam_off,
                color: Colors.grey[700],
                size: 60,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 36),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 32),
              IconButton(
                icon: Icon(cameraOn ? Icons.videocam : Icons.videocam_off, size: 36, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    cameraOn = !cameraOn;
                  });
                },
              ),
              const SizedBox(width: 32),
              GestureDetector(
                onTap: cameraOn ? () {/* lógica para tomar foto */} : null,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: cameraOn ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
