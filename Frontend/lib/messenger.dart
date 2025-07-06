import 'package:flutter/material.dart';
import 'friends.dart';
import 'widgets/custom_bottom_navbar.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({Key? key}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final List<Map<String, dynamic>> chats = [
    // Por ahora usamos datos de ejemplo, luego los conectaremos con el backend
    {
      'name': 'Ana',
      'avatar': 'A',
      'last': '¡Hola! ¿Cómo estás?',
      'time': '10:30',
      'unread': 2,
    },
    {
      'name': 'Luis',
      'avatar': 'L',
      'last': '¿Listo para la videollamada?',
      'time': '09:15',
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botón para ir a la pantalla de amigos
          IconButton(
            icon: const Icon(Icons.people, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: _ChatSearchDelegate(chats),
              );
              if (result != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(contact: result),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: chats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No tienes conversaciones',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FriendsPage(),
                        ),
                      );
                    },
                    child: const Text('Iniciar una conversación'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (context, index) =>
                  const Divider(indent: 72, endIndent: 16),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[700],
                    child: Text(
                      chat['avatar']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    chat['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chat['last']!),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['time']!,
                        style: TextStyle(
                          color: chat['unread'] > 0
                              ? Colors.blue[700]
                              : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      if (chat['unread'] > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue[700],
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat['unread'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(contact: chat),
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}

class _ChatSearchDelegate extends SearchDelegate<Map<String, dynamic>> {
  final List<Map<String, dynamic>> chats;

  _ChatSearchDelegate(this.chats);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, {});
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredChats = chats.where((chat) {
      return chat['name']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[700],
            child: Text(
              chat['avatar']!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(chat['name']!),
          subtitle: Text(chat['last']!),
          onTap: () {
            close(context, chat);
          },
        );
      },
    );
  }
}

// TODO: Implementar ChatPage
class ChatPage extends StatelessWidget {
  final Map<String, dynamic> contact;

  const ChatPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contact['name'])),
      body: const Center(child: Text('Chat en desarrollo')),
    );
  }
}
