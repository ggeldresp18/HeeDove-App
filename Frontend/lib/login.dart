import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'home.dart';
import 'services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  final String loginMutation = r'''
    mutation Login($loginData: LoginInput!) {
      login(loginData: $loginData) {
        accessToken
        tokenType
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 350,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Mutation(
                  options: MutationOptions(
                    document: gql(loginMutation),
                    onCompleted: (dynamic resultData) {
                      print("Login: Respuesta recibida - $resultData");
                      if (resultData != null && resultData['login'] != null) {
                        print(
                          "Login: Token recibido - ${resultData['login']['accessToken']}",
                        );
                        final response = resultData['login'];
                        final token = response['accessToken'];
                        final tokenType = response['tokenType'];

                        // Guardar el token
                        AuthService.saveToken(token, tokenType).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inicio de sesión exitoso'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        });
                      }
                    },
                    onError: (error) {
                      String errorMessage = 'Error de inicio de sesión';
                      if (error != null) {
                        if (error.graphqlErrors.isNotEmpty) {
                          errorMessage = error.graphqlErrors[0].message;
                        } else if (error.linkException != null) {
                          errorMessage = 'Error de conexión al servidor';
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bienvenido a\nHeeDove',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),

                        const Text("Correo electrónico"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _userController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu correo electrónico',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text("Contraseña"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu contraseña',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final variables = {
                                'loginData': {
                                  'email': _userController.text,
                                  'password': _passController.text,
                                },
                              };
                              print('Variables: $variables'); // Para debug
                              runMutation(variables);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF13639D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Iniciar Sesión'),
                          ),
                        ),

                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF05E3C7),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Regístrate'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
