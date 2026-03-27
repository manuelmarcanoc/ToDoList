import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  String email = '';
  String password = '';
  String error = '';
  bool isLogin = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        error = '';
      });
      try {
        if (isLogin) {
          await _auth.signInWithEmailAndPassword(email.trim(), password.trim());
        } else {
          await _auth.registerWithEmailAndPassword(email.trim(), password.trim());
        }
      } catch (e) {
        setState(() {
          error = 'Error de autenticación. Verifica la consola de Firebase o las credenciales.';
          _isLoading = false;
        });
      }
    }
  }

  void _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      error = '';
    });
    try {
      final user = await _auth.signInWithGoogle();
      if (user == null) {
        // Cancelado por el usuario
        setState(() => _isGoogleLoading = false);
      }
    } catch (e) {
      setState(() {
        error = 'Fallo en Google Sign-In. ¿Añadiste la clave SHA-1 en la consola de Firebase y actualizaste el google-services.json?';
        _isGoogleLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3D0000), // Very deep wine
              Color(0xFF800000), // Maroon/Bordeaux
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLogin ? Icons.lock_person_rounded : Icons.person_add_rounded,
                            size: 80,
                            color: const Color(0xFF6B0000), // Wine red
                          ),
                          const SizedBox(height: 24),
                          Text(
                            isLogin ? '¡Bienvenido de nuevo!' : 'Crea tu cuenta',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isLogin 
                              ? 'Inicia sesión para ver tus tareas' 
                              : 'Regístrate para empezar a organizarte',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val == null || val.isEmpty || !val.contains('@') 
                                ? 'Introduce un correo válido' 
                                : null,
                            onChanged: (val) => setState(() => email = val),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            obscureText: true,
                            validator: (val) => val == null || val.length < 6 
                                ? 'Debe tener al menos 6 caracteres' 
                                : null,
                            onChanged: (val) => setState(() => password = val),
                          ),
                          const SizedBox(height: 32),
                          if (error.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red.shade700),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      error,
                                      style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6B0000), // Wine red/Maroon
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _isLoading || _isGoogleLoading ? null : _submitForm,
                              child: _isLoading 
                                ? const SizedBox(
                                    height: 24, 
                                    width: 24, 
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  )
                                : Text(
                                    isLogin ? 'Entrar con Correo' : 'Registrar',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text('O', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                              ),
                              Expanded(child: Divider(thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: _isLoading || _isGoogleLoading ? null : _signInWithGoogle,
                              icon: _isGoogleLoading 
                                ? const SizedBox(
                                    height: 20, 
                                    width: 20, 
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue)
                                  )
                                : SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: const [
                                        Icon(Icons.circle, size: 24, color: Colors.blue),
                                        Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      ],
                                    ),
                                  ),
                              label: const Text(
                                'Continuar con Google',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF800000), // Deep maroon
                            ),
                            onPressed: () => setState(() {
                              isLogin = !isLogin;
                              error = '';
                            }),
                            child: Text(
                              isLogin 
                                  ? '¿No tienes cuenta? Regístrate aquí' 
                                  : '¿Ya tienes cuenta? Inicia sesión',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
