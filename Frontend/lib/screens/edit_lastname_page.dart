import 'package:flutter/material.dart';

class EditLastNamePage extends StatefulWidget {
  const EditLastNamePage({Key? key}) : super(key: key);

  @override
  State<EditLastNamePage> createState() => _EditLastNamePageState();
}

class _EditLastNamePageState extends State<EditLastNamePage> {
  final TextEditingController _controller = TextEditingController(
    text: 'Last name',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Apellidos'),
        backgroundColor: const Color(0xFF278B1C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apellidos actuales',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa tus nuevos apellidos',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí iría la lógica para guardar el cambio
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
