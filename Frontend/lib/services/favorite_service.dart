import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';

class FavoriteService {
  // Query para obtener favoritos
  static const String getUserFavoritesQuery = '''
    query GetUserFavorites {
      getUserFavorites {
        id
        userId
        itemType
        itemId
        createdAt
      }
    }
  ''';

  // Mutación para agregar favorito
  static const String addFavoriteMutation = '''
    mutation AddFavorite(\$itemType: String!, \$itemId: String!) {
      addFavorite(favorite: { itemType: \$itemType, itemId: \$itemId }) {
        id
        userId
        itemType
        itemId
        createdAt
      }
    }
  ''';

  // Mutación para eliminar favorito
  static const String removeFavoriteMutation = '''
    mutation RemoveFavorite(\$itemType: String!, \$itemId: String!) {
      removeFavorite(itemType: \$itemType, itemId: \$itemId)
    }
  ''';

  // Obtener favoritos del usuario
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      print("FavoriteService: Obteniendo favoritos");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      final QueryOptions options = QueryOptions(
        document: gql(getUserFavoritesQuery),
        fetchPolicy: FetchPolicy.noCache,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        print("FavoriteService: Error en la respuesta: ${result.exception}");
        throw result.exception!;
      }

      print("FavoriteService: Favoritos obtenidos: ${result.data}");
      final data = result.data!['getUserFavorites'];
      if (data == null) {
        return [];
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("FavoriteService: Error al obtener favoritos: $e");
      throw Exception('Error al obtener favoritos: ${e.toString()}');
    }
  }

  // Agregar favorito
  static Future<Map<String, dynamic>> addFavorite(
    String itemType,
    String itemId,
  ) async {
    try {
      print("FavoriteService: Agregando favorito");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      final MutationOptions options = MutationOptions(
        document: gql(addFavoriteMutation),
        variables: {'itemType': itemType, 'itemId': itemId},
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        print("FavoriteService: Error en la respuesta: ${result.exception}");
        throw result.exception!;
      }

      print("FavoriteService: Favorito agregado: ${result.data}");
      return result.data!['addFavorite'];
    } catch (e) {
      print("FavoriteService: Error al agregar favorito: $e");
      throw Exception('Error al agregar favorito: ${e.toString()}');
    }
  }

  // Eliminar favorito
  static Future<bool> removeFavorite(String itemType, String itemId) async {
    try {
      print("FavoriteService: Eliminando favorito");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      final MutationOptions options = MutationOptions(
        document: gql(removeFavoriteMutation),
        variables: {'itemType': itemType, 'itemId': itemId},
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        print("FavoriteService: Error en la respuesta: ${result.exception}");
        throw result.exception!;
      }

      print("FavoriteService: Favorito eliminado");
      return result.data!['removeFavorite'] as bool;
    } catch (e) {
      print("FavoriteService: Error al eliminar favorito: $e");
      throw Exception('Error al eliminar favorito: ${e.toString()}');
    }
  }
}
