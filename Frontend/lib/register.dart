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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF0F0FF), Color(0xFFE6F7F7)],
                ),
              ),
            ),
          ),
          const BubblesBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxHeight,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? screenWidth * 0.2 : 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (currentStep == 0)
                                _buildStep1()
                              else
                                _buildStep2(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            'Se parte de\nHeeDove!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF13639D),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildInputField("Nombres", "Ingresa tus nombres", _nombreController),
        const SizedBox(height: 20),
        _buildInputField(
          "Apellidos",
          "Ingresa tus apellidos",
          _apellidoController,
        ),
        const SizedBox(height: 20),
        _buildInputField(
          "Correo electrónico",
          "Ingresa tu correo electrónico",
          _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        const Text(
          "Condición",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButtonFormField<String>(
            value: _condicionSeleccionada,
            decoration: _inputDecoration("Selecciona tu condición"),
            items: condiciones
                .map((cond) => DropdownMenuItem(value: cond, child: Text(cond)))
                .toList(),
            onChanged: (value) =>
                setState(() => _condicionSeleccionada = value),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _validarPaso1,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13639D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Siguiente',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            'Se parte de\nHeeDove!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF13639D),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildInputField(
          "Nombre de usuario",
          "Elige un nombre de usuario",
          _usuarioController,
        ),
        const SizedBox(height: 20),
        _buildInputField(
          "Contraseña",
          "Crea una contraseña",
          _passwordController,
          isPassword: true,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => currentStep = 0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Atrás'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF05E3C7),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Registrar'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword,
            decoration: _inputDecoration(hint),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xFF13639D), width: 1),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  void _validarPaso1() {
    if (_nombreController.text.isEmpty ||
        _apellidoController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _condicionSeleccionada == null) {
      _showMsg("Por favor, completa todos los campos");
      return;
    }
    if (!_isValidEmail(_emailController.text)) {
      _showMsg("Por favor, ingresa un correo electrónico válido");
      return;
    }
    setState(() => currentStep = 1);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleRegister() async {
    if (_usuarioController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMsg("Por favor, completa todos los campos");
      return;
    }
    if (_passwordController.text.length < 6) {
      _showMsg("La contraseña debe tener al menos 6 caracteres");
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService.register(
        username: _usuarioController.text,
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _nombreController.text,
        lastName: _apellidoController.text,
        condition: _condicionSeleccionada!,
      );
      if (!mounted) return;
      _showMsg("¡Registro exitoso! Por favor, inicia sesión.");
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      _showMsg(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class BubblesBackground extends StatelessWidget {
  const BubblesBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth * 0.25;
            width = width.clamp(100, 180);
            return SizedBox(
              width: width,
              height: constraints.maxHeight,
              child: CustomPaint(painter: BubblesPainter()),
            );
          },
        ),
      ),
    );
  }
}

class BubblesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFBBA9F4),
      const Color(0xFF9DDCF4),
      const Color(0xFF77D0F1),
    ];

    final gradient = (Rect rect) => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    ).createShader(rect);

    final circles = [
      Offset(size.width * 0.4, size.height * 0.05),
      Offset(size.width * 0.2, size.height * 0.20),
      Offset(size.width * 0.5, size.height * 0.35),
      Offset(size.width * 0.3, size.height * 0.50),
      Offset(size.width * 0.5, size.height * 0.65),
      Offset(size.width * 0.2, size.height * 0.80),
      Offset(size.width * 0.6, size.height * 0.95),
    ];

    final radii = [55.0, 42.0, 50.0, 38.0, 48.0, 35.0, 55.0];

    for (int i = 0; i < circles.length; i++) {
      final rect = Rect.fromCircle(center: circles[i], radius: radii[i]);
      final paint = Paint()..shader = gradient(rect);
      canvas.drawCircle(circles[i], radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
