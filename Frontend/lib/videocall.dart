import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navbar.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool showContacts = false;

  final List<Map<String, String>> onlineUsers = [
    {'name': 'Ana', 'avatar': 'A'},
    {'name': 'Luis', 'avatar': 'L'},
    {'name': 'Sofía', 'avatar': 'S'},
    {'name': 'Carlos', 'avatar': 'C'},
    {'name': 'Marta', 'avatar': 'M'},
  ];

  final List<Map<String, String>> recentCalls = [
    {'name': 'Ana', 'avatar': 'A'},
    {'name': 'Luis', 'avatar': 'L'},
    {'name': 'Carlos', 'avatar': 'C'},
  ];

  final List<Map<String, String>> contacts = [
    {'name': 'Ana', 'avatar': 'A'},
    {'name': 'Luis', 'avatar': 'L'},
    {'name': 'Sofía', 'avatar': 'S'},
    {'name': 'Carlos', 'avatar': 'C'},
    {'name': 'Marta', 'avatar': 'M'},
    {'name': 'Pedro', 'avatar': 'P'},
    {'name': 'Lucía', 'avatar': 'L'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = showContacts;
    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2ECC40),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 24),
              width: double.infinity,
              child: const Text(
                'Videollamada',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: onlineUsers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final user = onlineUsers[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.green[700],
                        child: Text(
                          user['avatar']!,
                          style: const TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['name']!,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showContacts = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !showContacts ? Colors.green : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            'Recientes',
                            style: TextStyle(
                              color: !showContacts ? Colors.white : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showContacts = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: showContacts ? Colors.green : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            'Contactos',
                            style: TextStyle(
                              color: showContacts ? Colors.white : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Aquí puedes agregar el contenido de Recientes o Contactos
            const SizedBox(height: 32),
            Expanded(
              child: showContacts
                  ? ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: contacts.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.white,
                        thickness: 1,
                        height: 1,
                        indent: 24,
                        endIndent: 24,
                      ),
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[700],
                            child: Text(contact['avatar']!, style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(
                            contact['name']!,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.phone, color: Colors.green),
                            onPressed: () {},
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      itemCount: recentCalls.length,
                      itemBuilder: (context, index) {
                        final call = recentCalls[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green[700],
                              child: Text(call['avatar']!, style: const TextStyle(color: Colors.white)),
                            ),
                            title: Text(
                              call['name']!,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline, color: Colors.blue),
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      ),
    );
  }
}
