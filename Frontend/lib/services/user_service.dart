import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';

class UserService {
  static Future<Map<String, dynamic>> getCurrentUser() async {
    const String query = '''
      query GetCurrentUser {
        me {
          id
          firstName
          lastName
          email
          friendCode
        }
      }
    ''';

    try {
      final GraphQLClient client = await GraphQLConfig.getClient();
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(query),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw Exception(
          result.exception?.graphqlErrors.first.message ?? 'Error desconocido',
        );
      }

      return result.data?['me'] as Map<String, dynamic>;
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      throw Exception('Error al obtener datos del usuario');
    }
  }
}
