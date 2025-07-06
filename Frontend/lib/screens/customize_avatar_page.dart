import 'package:flutter/material.dart';

class CustomizeAvatarPage extends StatefulWidget {
  const CustomizeAvatarPage({Key? key}) : super(key: key);

  @override
  State<CustomizeAvatarPage> createState() => _CustomizeAvatarPageState();
}

class _CustomizeAvatarPageState extends State<CustomizeAvatarPage> {
  Color selectedColor = Colors.grey;
  IconData selectedIcon = Icons.person;

  final List<Color> colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];

  final List<IconData> iconOptions = [
    Icons.person,
    Icons.face,
    Icons.emoji_emotions,
    Icons.sentiment_satisfied,
    Icons.psychology,
    Icons.sports_esports,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar Avatar'),
        backgroundColor: const Color(0xFF278B1C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Vista previa del avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: selectedColor,
              child: Icon(selectedIcon, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 32),

            // Selector de colores
            const Text(
              'Elige un color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: colorOptions.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == color
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Selector de íconos
            const Text(
              'Elige un ícono',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: iconOptions.map((icon) {
                return GestureDetector(
                  onTap: () => setState(() => selectedIcon = icon),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedIcon == icon
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(icon),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí iría la lógica para guardar los cambios
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF278B1C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
