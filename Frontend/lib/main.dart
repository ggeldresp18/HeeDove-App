import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'profile.dart';
import 'settings.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  final httpLink = HttpLink('http://10.0.2.2:8000/graphql');

  final client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(GraphQLProvider(client: client, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Definimos rutas aquí
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(), 
      },
      initialRoute: '/',
    );
  }
}
