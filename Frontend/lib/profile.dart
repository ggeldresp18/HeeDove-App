import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditingUsername = false;
  bool isEditingName = false;
  bool isEditingLastName = false;

  String username = 'User040325';
  String name = 'Nombre12345';
  String lastName = 'Last name';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = username;
    nameController.text = name;
    lastNameController.text = lastName;
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Widget _buildEditableField({
    required String title,
    required String value,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
  }) {
    if (isEditing) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Color(0xFF278B1C)),
                  onPressed: onSave,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              // Avatar y título
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Perfil',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // Campos editables
              _buildEditableField(
                title: 'Usuario:',
                value: username,
                controller: usernameController,
                isEditing: isEditingUsername,
                onEdit: () => setState(() {
                  isEditingUsername = true;
                  isEditingName = false;
                  isEditingLastName = false;
                }),
                onSave: () => setState(() {
                  username = usernameController.text;
                  isEditingUsername = false;
                }),
              ),
              _buildEditableField(
                title: 'Nombre:',
                value: name,
                controller: nameController,
                isEditing: isEditingName,
                onEdit: () => setState(() {
                  isEditingUsername = false;
                  isEditingName = true;
                  isEditingLastName = false;
                }),
                onSave: () => setState(() {
                  name = nameController.text;
                  isEditingName = false;
                }),
              ),
              _buildEditableField(
                title: 'Apellidos:',
                value: lastName,
                controller: lastNameController,
                isEditing: isEditingLastName,
                onEdit: () => setState(() {
                  isEditingUsername = false;
                  isEditingName = false;
                  isEditingLastName = true;
                }),
                onSave: () => setState(() {
                  lastName = lastNameController.text;
                  isEditingLastName = false;
                }),
              ),

              // Personalizar avatar (sin edición inline)
              InkWell(
                onTap: () {
                  // Aquí iría la lógica para personalizar el avatar
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Personalizar avatar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF278B1C),
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Color(0xFF278B1C)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
