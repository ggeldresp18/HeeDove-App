import 'package:flutter/material.dart';
import 'community.dart';
import 'det_image.dart';
import 'det_sound.dart';
import 'messenger.dart';
import 'profile.dart';
import 'settings.dart';
import 'widgets/custom_bottom_navbar.dart';
import 'videocall.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  final Set<String> favorites = {};

  final List<Map<String, dynamic>> allFeatures = [
    {
      'icon': Icons.video_call,
      'title': 'Videollamada',
      'desc': 'Traducción de señas y transcripción de voz',
      'category': 'video',
    },
    {
      'icon': Icons.group,
      'title': 'Comunidad',
      'desc': 'Interactúa con miles de usuarios',
      'category': 'social',
    },
    {
      'icon': Icons.visibility,
      'title': 'Detección de imágenes',
      'desc': 'Percibe los objetos a tu alrededor',
      'category': 'visual',
    },
    {
      'icon': Icons.hearing,
      'title': 'Detección de sonidos',
      'desc': 'Percibe los sonidos a tu alrededor',
      'category': 'audio',
    },
    {
      'icon': Icons.chat,
      'title': 'Amigos',
      'desc': 'Chatea con tus amigos',
      'category': 'social',
    },
  ];

  List<Map<String, dynamic>> get filteredFeatures {
    if (selectedCategory == 'All') return allFeatures;
    if (selectedCategory == 'Favorites') {
      return allFeatures.where((f) => favorites.contains(f['title'])).toList();
    }
    if (selectedCategory == 'deteccion') {
      return allFeatures
          .where((f) => f['category'] == 'visual' || f['category'] == 'audio')
          .toList();
    }
    return allFeatures.where((f) => f['category'] == selectedCategory).toList();
  }

  final List<Map<String, dynamic>> filters = [
    {'label': 'All', 'icon': Icons.apps},
    {'label': 'video', 'icon': Icons.video_call},
    {'label': 'deteccion', 'icon': Icons.search},
    {'label': 'social', 'icon': Icons.group},
    {'label': 'Favorites', 'icon': Icons.favorite},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Bienvenido a HeeDove',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF60D9C3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Usuario040325',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Icon(Icons.account_circle, color: Colors.white, size: 40),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text('¿Qué haremos hoy?', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: filters.map((filter) {
                      final isSelected = selectedCategory == filter['label'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = filter['label'];
                            });
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF278B1C)
                                  : const Color(0xFF2A4680),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              filter['icon'],
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0x8904C494),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: filteredFeatures.map((feature) {
                    final isFav = favorites.contains(feature['title']);
                    final isVideoCall = feature['title'] == 'Videollamada';
                    final isCommunity = feature['title'] == 'Comunidad';
                    final isMessenger = feature['title'] == 'Amigos';
                    final isDetImage =
                        feature['title'] == 'Detección de imágenes';
                    final isDetSound =
                        feature['title'] == 'Detección de sonidos';
                    return GestureDetector(
                      onTap: isVideoCall
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VideoCallPage(),
                                ),
                              );
                            }
                          : isCommunity
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CommunityPage(),
                                ),
                              );
                            }
                          : isMessenger
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MessengerPage(),
                                ),
                              );
                            }
                          : isDetImage
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DetImagePage(),
                                ),
                              );
                            }
                          : isDetSound
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DetSoundPage(),
                                ),
                              );
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0CA3C3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  feature['icon'],
                                  size: 30,
                                  color: Colors.white,
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (isFav) {
                                        favorites.remove(feature['title']);
                                      } else {
                                        favorites.add(feature['title']);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              feature['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              feature['desc'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
