import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:heedove/services/graphql_config.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _tokenTypeKey = 'token_type';

  // Mutación de registro
  static const String registerMutation = '''
    mutation Register(\$userData: UserInput!) {
      register(userData: \$userData) {
        id
        email
        username
        firstName
        lastName
        condition
        isActive
        createdAt
      }
    }
  ''';

  // Método para registrar un usuario
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String condition,
  }) async {
    try {
      print("AuthService: Iniciando registro");
      final GraphQLClient client = GraphQLConfig.graphQLClient();

      print("AuthService: Cliente GraphQL creado");
      final MutationOptions options = MutationOptions(
        document: gql(registerMutation),
        variables: {
          'userData': {
            'username': username,
            'password': password,
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'condition': condition,
          },
        },
      );

      print(
        "AuthService: Enviando mutación al servidor con variables: ${options.variables}",
      );
      final QueryResult result = await client.mutate(options);

      print("AuthService: Respuesta recibida");
      if (result.hasException) {
        print("AuthService: Error en la respuesta: ${result.exception}");
        final error =
            result.exception?.graphqlErrors.first.message ??
            "Error desconocido";

        // Manejamos diferentes tipos de errores
        if (error.contains("duplicate key")) {
          if (error.contains("users_email_key")) {
            throw Exception(
              "El correo electrónico ya está registrado. Por favor, usa otro.",
            );
          } else if (error.contains("users_username_key")) {
            throw Exception(
              "El nombre de usuario ya está registrado. Por favor, elige otro.",
            );
          }
        }
        throw Exception(error);
      }

      print("AuthService: Datos recibidos: ${result.data}");
      final userData = result.data!['register'];

      return userData;
    } catch (e) {
      print("AuthService: Error durante el registro: $e");
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // Guardar el token
  static Future<void> saveToken(String token, String type) async {
    print("AuthService: Guardando token - Tipo: $type, Token: $token");

    // Asegurarse de que el tipo esté en minúsculas para consistencia
    type = type.toLowerCase();

    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _tokenTypeKey, value: type);

    // Verificar que se guardó correctamente
    final savedToken = await _storage.read(key: _tokenKey);
    final savedType = await _storage.read(key: _tokenTypeKey);
    print("AuthService: Token guardado - Tipo: $savedType, Token: $savedToken");
  }

  // Obtener el token completo (con el tipo)
  static Future<String?> getFullToken() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      final type = await _storage.read(key: _tokenTypeKey);

      if (token == null || type == null) {
        print("AuthService: No se encontró token o tipo de token");
        return null;
      }

      // Formatear el token correctamente
      final fullToken = "${type.toLowerCase()} $token";
      print("AuthService: Token completo recuperado: $fullToken");
      return fullToken;
    } catch (e) {
      print("AuthService: Error al recuperar token: $e");
      return null;
    }
  }

  // Método para borrar el token (logout)
  static Future<void> clearToken() async {
    print("AuthService: Borrando token");
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _tokenTypeKey);
  }

  // Verificar si hay un token guardado
  static Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }
}
