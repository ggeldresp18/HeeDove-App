import 'package:flutter/material.dart';
import 'package:heedove/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int currentStep = 0;
  bool _isLoading = false;

  // Controladores para los campos
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _condicionSeleccionada;

  final List<String> condiciones = [
    'Discapacidad visual',
    'Discapacidad auditiva',
    'Prefiero no decirlo',
  ];

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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : currentStep == 0
                    ? _buildStep1()
                    : _buildStep2(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Pantalla 1
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Se parte de\nHeeDove!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        const Text("Nombres"),
        const SizedBox(height: 8),
        TextField(
          controller: _nombreController,
          decoration: _inputDecoration("Ingresa tus nombres"),
        ),

        const SizedBox(height: 20),
        const Text("Apellidos"),
        const SizedBox(height: 8),
        TextField(
          controller: _apellidoController,
          decoration: _inputDecoration("Ingresa tus apellidos"),
        ),

        const SizedBox(height: 20),
        const Text("Correo electrónico"),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDecoration("Ingresa tu correo electrónico"),
        ),

        const SizedBox(height: 20),
        const Text("Condición"),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _condicionSeleccionada,
          decoration: _inputDecoration("Selecciona tu condición"),
          items: condiciones
              .map((cond) => DropdownMenuItem(value: cond, child: Text(cond)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _condicionSeleccionada = value;
            });
          },
        ),

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_nombreController.text.isEmpty ||
                  _apellidoController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _condicionSeleccionada == null) {
                _showMsg("Completa todos los campos");
                return;
              }

              // Validar formato de email
              if (!_isValidEmail(_emailController.text)) {
                _showMsg("Por favor, ingresa un correo electrónico válido");
                return;
              }

              setState(() {
                currentStep = 1;
              });
            },
            style: _btnStyle(const Color(0xFF13639D)),
            child: const Text("Siguiente"),
          ),
        ),
      ],
    );
  }

  // Pantalla 2
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Se parte de\nHeeDove!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        const Text("Nombre de usuario"),
        const SizedBox(height: 8),
        TextField(
          controller: _usuarioController,
          decoration: _inputDecoration("Elige un nombre de usuario"),
        ),

        const SizedBox(height: 20),
        const Text("Contraseña"),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: _inputDecoration("Crea una contraseña"),
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentStep = 0;
                  });
                },
                style: _btnStyle(Colors.grey.shade300, textColor: Colors.black),
                child: const Text("Atrás"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: _btnStyle(
                  const Color(0xFF05E3C7),
                  textColor: Colors.black,
                ),
                child: const Text("Registrar"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Validar formato de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Método para manejar el registro
  Future<void> _handleRegister() async {
    // Validaciones
    if (_usuarioController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMsg("Por favor, completa todos los campos");
      return;
    }

    // Validar longitud mínima de contraseña
    if (_passwordController.text.length < 6) {
      _showMsg("La contraseña debe tener al menos 6 caracteres");
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("Iniciando registro con datos:");
      print("Email: ${_emailController.text}");
      print("Usuario: ${_usuarioController.text}");
      print("Nombre: ${_nombreController.text}");
      print("Apellido: ${_apellidoController.text}");
      print("Condición: $_condicionSeleccionada");

      final result = await AuthService.register(
        username: _usuarioController.text,
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _nombreController.text,
        lastName: _apellidoController.text,
        condition: _condicionSeleccionada!,
      );

      print("Respuesta del servidor: $result");

      if (!mounted) return;

      // Mostrar mensaje de éxito
      _showMsg("¡Registro exitoso! Por favor, inicia sesión.");

      // Navegar a la pantalla de login
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      print("Error durante el registro: $e");
      _showMsg(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Reutilizable: decoración de campos
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  // Reutilizable: estilo de botón
  ButtonStyle _btnStyle(Color bg, {Color textColor = Colors.white}) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: textColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  // Reutilizable: mostrar mensaje
  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
