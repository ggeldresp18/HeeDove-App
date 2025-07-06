import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/friend_service.dart';
import 'services/friend_request_service.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _receivedRequests = [];
  List<Map<String, dynamic>> _sentRequests = [];
  String _error = '';
  final _friendCodeController = TextEditingController();
  String? _myFriendCode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      print("FriendsPage: Iniciando carga de datos");

      print("FriendsPage: Obteniendo amigos...");
      final friends = await FriendService.getFriends();
      print("FriendsPage: ${friends.length} amigos encontrados");

      print("FriendsPage: Obteniendo solicitudes pendientes...");
      final pendingRequests = await FriendRequestService.getPendingRequests();
      print(
        "FriendsPage: ${pendingRequests.length} solicitudes pendientes encontradas",
      );

      print("FriendsPage: Obteniendo solicitudes enviadas...");
      final sentRequests = await FriendRequestService.getSentRequests();
      if (sentRequests.isNotEmpty) {
        final senderData = sentRequests[0]['sender'] as Map<String, dynamic>?;
        _myFriendCode = senderData?['friendCode'] as String?;
      } else if (friends.isNotEmpty) {
        // Si no hay solicitudes enviadas pero sí hay amigos, intentar obtener el código de ahí
        final userData = friends[0]['user'] as Map<String, dynamic>?;
        _myFriendCode = userData?['friendCode'] as String?;
      }
      print(
        "FriendsPage: ${sentRequests.length} solicitudes enviadas encontradas",
      );

      if (mounted) {
        setState(() {
          _friends = friends;
          _receivedRequests = pendingRequests;
          _sentRequests = sentRequests;
          _isLoading = false;
        });
        print(
          "FriendsPage: Estado actualizado - Amigos: ${_friends.length}, Recibidas: ${_receivedRequests.length}, Enviadas: ${_sentRequests.length}",
        );
      }
    } catch (e, stackTrace) {
      print("FriendsPage: Error al cargar datos");
      print("Error: $e");
      print("StackTrace: $stackTrace");

      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _copyFriendCode() async {
    if (_myFriendCode != null) {
      await Clipboard.setData(ClipboardData(text: _myFriendCode!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código copiado al portapapeles'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _handleRequestAction(String requestId, bool accept) async {
    try {
      if (accept) {
        await FriendRequestService.acceptRequest(requestId);
      } else {
        await FriendRequestService.rejectRequest(requestId);
      }

      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              accept ? 'Solicitud aceptada' : 'Solicitud rechazada',
            ),
            backgroundColor: accept ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showAddFriendDialog() async {
    _friendCodeController
        .clear(); // Limpiar el campo antes de mostrar el diálogo
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar amigo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingresa el código de amigo de 10 dígitos:'),
              const SizedBox(height: 10),
              TextField(
                controller: _friendCodeController,
                decoration: const InputDecoration(
                  hintText: 'Código de amigo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enviar solicitud'),
              onPressed: () async {
                if (_friendCodeController.text.length == 10) {
                  try {
                    await FriendRequestService.sendRequestByCode(
                      _friendCodeController.text,
                    );
                    await _loadData();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Solicitud enviada exitosamente'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El código debe tener 10 dígitos'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Amigos'),
        backgroundColor: const Color(0xFF278B1C),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'Amigos'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Recibidas'),
                  const SizedBox(width: 4),
                  if (_receivedRequests.isNotEmpty)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: const Color(0xFF13639D),
                      child: Text(
                        _receivedRequests.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enviadas'),
                  const SizedBox(width: 4),
                  if (_sentRequests.isNotEmpty)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.orange[700],
                      child: Text(
                        _sentRequests.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $_error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFriendsList(),
                  _buildReceivedRequestsList(),
                  _buildSentRequestsTab(),
                ],
              ),
            ),
    );
  }

  Widget _buildFriendsList() {
    if (_friends.isEmpty) {
      return const Center(child: Text('No tienes amigos agregados aún'));
    }

    return ListView.separated(
      itemCount: _friends.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final friend = _friends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[700],
            child: Text(
              ((friend['friend'] ?? friend['user'])['firstName'] as String? ??
                      'U')[0]
                  .toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            '${(friend['friend'] ?? friend['user'])['firstName']} ${(friend['friend'] ?? friend['user'])['lastName']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '@${(friend['friend'] ?? friend['user'])['username']}',
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  ((friend['friend'] ?? friend['user'])['isActive'] as bool?) ??
                      false
                  ? Colors.green[100]
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              ((friend['friend'] ?? friend['user'])['isActive'] as bool?) ??
                      false
                  ? 'Activo'
                  : 'Inactivo',
              style: TextStyle(
                color:
                    ((friend['friend'] ?? friend['user'])['isActive']
                            as bool?) ??
                        false
                    ? Colors.green[700]
                    : Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceivedRequestsList() {
    if (_receivedRequests.isEmpty) {
      return const Center(child: Text('No tienes solicitudes pendientes'));
    }

    return ListView.separated(
      itemCount: _receivedRequests.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final requestData = _receivedRequests[index];
        final senderData = requestData['sender'] as Map<String, dynamic>?;

        if (senderData == null) {
          return const ListTile(
            title: Text('Error: Información del remitente no disponible'),
          );
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[700],
            child: Text(
              (senderData['firstName'] as String)[0].toString().toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            '${senderData['firstName']} ${senderData['lastName']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('@${senderData['username']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: Colors.green,
                onPressed: () => _handleRequestAction(requestData['id'], true),
              ),
              IconButton(
                icon: const Icon(Icons.cancel_outlined),
                color: Colors.red,
                onPressed: () => _handleRequestAction(requestData['id'], false),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSentRequestsTab() {
    return Column(
      children: [
        if (_myFriendCode != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tu código de amigo:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.copy),
                        label: const Text('Copiar'),
                        onPressed: _copyFriendCode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _myFriendCode!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Color(0xFF278B1C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: _showAddFriendDialog,
            icon: const Icon(Icons.person_add),
            label: const Text('Agregar amigo por código'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF278B1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: _sentRequests.isEmpty
              ? const Center(
                  child: Text('No has enviado solicitudes de amistad'),
                )
              : ListView.separated(
                  itemCount: _sentRequests.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final requestData = _sentRequests[index];
                    final receiverData =
                        requestData['receiver'] as Map<String, dynamic>?;

                    if (receiverData == null) {
                      return const ListTile(
                        title: Text(
                          'Error: Información del destinatario no disponible',
                        ),
                      );
                    }

                    String statusText;
                    Color statusColor;
                    switch (requestData['status']) {
                      case 'PENDING':
                        statusText = 'Pendiente';
                        statusColor = Colors.orange;
                        break;
                      case 'REJECTED':
                        statusText = 'Rechazada';
                        statusColor = Colors.red;
                        break;
                      default:
                        statusText = 'Desconocido';
                        statusColor = Colors.grey;
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[700],
                        child: Text(
                          (receiverData['firstName'] as String)[0]
                              .toString()
                              .toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        '${receiverData['firstName']} ${receiverData['lastName']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('@${receiverData['username']}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _friendCodeController.dispose();
    super.dispose();
  }
}
