import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'auth_service.dart';

class GraphQLConfig {
  static String uri =
      'http://10.0.2.2:8000/graphql'; // Actualiza esta URL según tu servidor

  static ValueNotifier<GraphQLClient> initializeClient() {
    return ValueNotifier(graphQLClient());
  }

  static GraphQLClient graphQLClient() {
    final HttpLink httpLink = HttpLink(uri);

    final AuthLink authLink = AuthLink(
      getToken: () async {
        try {
          final token = await AuthService.getFullToken();
          print("Token recuperado: $token");

          if (token == null || token.isEmpty) {
            print("Error: Token no disponible");
            return null;
          }

          // Asegurarse de que el token tiene el formato correcto
          if (!token.toLowerCase().startsWith('bearer ')) {
            print("Añadiendo prefix 'Bearer' al token");
            return 'Bearer $token';
          }

          print("Token con formato correcto: $token");
          return token;
        } catch (e) {
          print("Error al obtener token: $e");
          return null;
        }
      },
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        mutate: Policies(fetch: FetchPolicy.noCache),
      ),
    );
  }

  static Future<GraphQLClient> getClient() async {
    final HttpLink httpLink = HttpLink(uri);

    final AuthLink authLink = AuthLink(
      getToken: () async {
        try {
          final token = await AuthService.getFullToken();
          print("Token recuperado: $token");

          if (token == null || token.isEmpty) {
            print("Error: Token no disponible");
            return null;
          }

          if (!token.toLowerCase().startsWith('bearer ')) {
            print("Añadiendo prefix 'Bearer' al token");
            return 'Bearer $token';
          }

          print("Token con formato correcto: $token");
          return token;
        } catch (e) {
          print("Error al obtener token: $e");
          return null;
        }
      },
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        mutate: Policies(fetch: FetchPolicy.noCache),
      ),
    );
  }
}
