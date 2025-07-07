import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:heedove/services/graphql_config.dart';
import 'package:heedove/services/auth_service.dart';

class FriendRequestService {
  // Query para obtener solicitudes pendientes
  static const String getPendingRequestsQuery = '''
    query GetReceivedRequests {
      getReceivedFriendRequests {
        __typename
        id
        senderId
        receiverId
        status
        createdAt
        updatedAt
        sender {
          __typename
          id
          email
          username
          firstName
          lastName
          condition
          isActive
          createdAt
          friendCode
        }
        receiver {
          __typename
          id
          email
          username
          firstName
          lastName
          condition
          isActive
          createdAt
          friendCode
        }
      }
    }
  ''';

  // Query para obtener solicitudes enviadas
  static const String getSentRequestsQuery = '''
    query GetSentRequests {
      getSentFriendRequests {
        __typename
        id
        senderId
        receiverId
        status
        createdAt
        updatedAt
        sender {
          __typename
          id
          email
          username
          firstName
          lastName
          condition
          isActive
          createdAt
          friendCode
        }
        receiver {
          __typename
          id
          email
          username
          firstName
          lastName
          condition
          isActive
          createdAt
          friendCode
        }
      }
    }
  ''';

  // Mutación para aceptar solicitud
  static const String acceptRequestMutation = '''
    mutation AcceptRequest(\$requestId: String!) {
      acceptFriendRequest(requestId: \$requestId) {
        __typename
        id
        userId
        friendId
        createdAt
        user {
          __typename
          id
          email
          username
          firstName
          lastName
          condition
          isActive
          createdAt
          friendCode
        }
        friend {
          __typename
          id
          email
          username
          firstName
          lastName
          condition
          isActive
          createdAt
          friendCode
        }
      }
    }
  ''';

  // Mutación para rechazar solicitud
  static const String rejectRequestMutation = '''
    mutation RejectRequest(\$requestId: String!) {
      rejectFriendRequest(requestId: \$requestId) {
        __typename
        id
        senderId
        receiverId
        status
        createdAt
        updatedAt
      }
    }
  ''';

  // Mutación para enviar solicitud por código
  static const String sendRequestByCodeMutation = '''
    mutation SendFriendRequestByCode(\$friendCode: String!) {
      sendFriendRequestByCode(request: { friendCode: \$friendCode }) {
        id
        senderId
        receiverId
        status
        createdAt
        updatedAt
        sender {
          id
          email
          username
          firstName
          lastName
          condition
          isActive
          createdAt
          friendCode
        }
        receiver {
          id
          email
          username
          firstName
          lastName
          condition
          isActive
          createdAt
          friendCode
        }
      }
    }
  ''';

  // Obtener solicitudes pendientes
  static Future<List<Map<String, dynamic>>> getPendingRequests() async {
    try {
      print("FriendRequestService: Obteniendo solicitudes pendientes");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      // Imprimir el token para depuración
      final token = await AuthService.getFullToken();
      print("Token de autenticación: $token");

      final QueryOptions options = QueryOptions(
        document: gql(getPendingRequestsQuery),
        fetchPolicy: FetchPolicy.noCache,
      );

      print("Ejecutando consulta getPendingRequests...");
      final QueryResult result = await client.query(options);

      if (result.hasException) {
        print(
          "FriendRequestService: Error en la respuesta: ${result.exception}",
        );
        throw result.exception!;
      }

      print("Respuesta completa: ${result.data}");
      final data = result.data!['getReceivedFriendRequests'];
      print("Datos recibidos: $data");

      if (data == null) {
        print("No se encontraron solicitudes pendientes");
        return [];
      }

      final requests = List<Map<String, dynamic>>.from(data);
      print("Número de solicitudes pendientes encontradas: ${requests.length}");
      print(
        "Primera solicitud: ${requests.isNotEmpty ? requests[0] : 'ninguna'}",
      );
      return requests;
    } catch (e) {
      print("FriendRequestService: Error al obtener solicitudes: $e");
      throw Exception(
        'Error al obtener solicitudes de amistad: ${e.toString()}',
      );
    }
  }

  // Obtener solicitudes enviadas
  static Future<List<Map<String, dynamic>>> getSentRequests() async {
    try {
      print("FriendRequestService: Obteniendo solicitudes enviadas");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      final QueryOptions options = QueryOptions(
        document: gql(getSentRequestsQuery),
        fetchPolicy: FetchPolicy.noCache,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        print(
          "FriendRequestService: Error en la respuesta: ${result.exception}",
        );
        throw result.exception!;
      }

      final data = result.data!['getSentFriendRequests'];
      if (data == null) {
        return [];
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("FriendRequestService: Error al obtener solicitudes enviadas: $e");
      throw Exception('Error al obtener solicitudes enviadas: ${e.toString()}');
    }
  }

  // Aceptar solicitud de amistad
  static Future<void> acceptRequest(String requestId) async {
    try {
      print("FriendRequestService: Aceptando solicitud $requestId");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      print("Variables de la mutación: {'requestId': $requestId}");
      final MutationOptions options = MutationOptions(
        document: gql(acceptRequestMutation),
        variables: {'requestId': requestId},
        fetchPolicy: FetchPolicy.noCache,
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        print(
          "FriendRequestService: Error en la respuesta: ${result.exception}",
        );
        throw result.exception!;
      }

      print("FriendRequestService: Solicitud aceptada exitosamente");
    } catch (e) {
      print("FriendRequestService: Error al aceptar solicitud: $e");
      throw Exception('Error al aceptar solicitud de amistad: ${e.toString()}');
    }
  }

  // Rechazar solicitud de amistad
  static Future<void> rejectRequest(String requestId) async {
    try {
      print("FriendRequestService: Rechazando solicitud $requestId");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      final MutationOptions options = MutationOptions(
        document: gql(rejectRequestMutation),
        variables: {'requestId': requestId},
        fetchPolicy: FetchPolicy.noCache,
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        print(
          "FriendRequestService: Error en la respuesta: ${result.exception}",
        );
        throw result.exception!;
      }

      print("FriendRequestService: Solicitud rechazada exitosamente");
    } catch (e) {
      print("FriendRequestService: Error al rechazar solicitud: $e");
      throw Exception(
        'Error al rechazar solicitud de amistad: ${e.toString()}',
      );
    }
  }

  // Método para enviar solicitud por código
  static Future<Map<String, dynamic>> sendRequestByCode(
    String friendCode,
  ) async {
    try {
      final GraphQLClient client = await GraphQLConfig.getClient();
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(sendRequestByCodeMutation),
          variables: {'friendCode': friendCode},
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      return result.data?['sendFriendRequestByCode'] ?? {};
    } catch (e) {
      print('Error al enviar solicitud por código: $e');
      rethrow;
    }
  }
}
