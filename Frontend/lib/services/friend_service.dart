import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:heedove/services/graphql_config.dart';

class FriendService {
  // Query para obtener amistades
  static const String getFriendsQuery = '''
    query GetMyFriends {
      myFriends {
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

  // Método para obtener la lista de amigos
  static Future<List<Map<String, dynamic>>> getFriends() async {
    try {
      print("FriendService: Obteniendo lista de amigos");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      final QueryOptions options = QueryOptions(
        document: gql(getFriendsQuery),
        fetchPolicy: FetchPolicy.noCache,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        print("FriendService: Error en la respuesta: ${result.exception}");
        throw result.exception!;
      }

      print("FriendService: Amigos obtenidos: ${result.data}");
      final data = result.data!['myFriends'];
      if (data == null) {
        return [];
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("FriendService: Error al obtener amigos: $e");
      throw Exception('Error al obtener la lista de amigos: ${e.toString()}');
    }
  }
}
