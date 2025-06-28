import 'package:flutter/material.dart';
import 'widgets/custom_bottom_navbar.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({Key? key}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final List<Map<String, String>> chats = [
    {'name': 'Ana', 'avatar': 'A', 'last': '¡Hola! ¿Cómo estás?', 'time': '10:30'},
    {'name': 'Luis', 'avatar': 'L', 'last': '¿Listo para la videollamada?', 'time': '09:15'},
    {'name': 'Sofía', 'avatar': 'S', 'last': '¡Nos vemos luego!', 'time': 'Ayer'},
    {'name': 'Carlos', 'avatar': 'C', 'last': '¿Tienes un minuto?', 'time': 'Ayer'},
    {'name': 'Marta', 'avatar': 'M', 'last': 'Gracias por la ayuda', 'time': 'Lun'},
  ];
  String filter = '';

  @override
  Widget build(BuildContext context) {
    final filteredChats = chats.where((c) => c['name']!.toLowerCase().contains(filter.toLowerCase())).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Chat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: _ContactSearchDelegate(chats),
              );
              if (result != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage(contact: result)),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: filteredChats.length,
        separatorBuilder: (context, index) => const Divider(indent: 72, endIndent: 16),
        itemBuilder: (context, index) {
          final chat = filteredChats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: Text(chat['avatar']!, style: const TextStyle(color: Colors.white)),
            ),
            title: Text(chat['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chat['last']!),
            trailing: Text(chat['time']!, style: const TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(contact: chat)),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}

class ChatPage extends StatelessWidget {
  final Map<String, String> contact;
  const ChatPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: Text(contact['avatar']!, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Text(contact['name']!, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: Center(
        child: Text('Conversación con ${contact['name']}'),
      ),
    );
  }
}

class _ContactSearchDelegate extends SearchDelegate<Map<String, String>> {
  final List<Map<String, String>> chats;
  _ContactSearchDelegate(this.chats);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, {}),
      );

  @override
  Widget buildResults(BuildContext context) {
    final results = chats.where((c) => c['name']!.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(
      children: results
          .map((c) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  child: Text(c['avatar']!, style: const TextStyle(color: Colors.white)),
                ),
                title: Text(c['name']!),
                onTap: () => close(context, c),
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = chats.where((c) => c['name']!.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView(
      children: suggestions
          .map((c) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  child: Text(c['avatar']!, style: const TextStyle(color: Colors.white)),
                ),
                title: Text(c['name']!),
                onTap: () => close(context, c),
              ))
          .toList(),
    );
  }
}
