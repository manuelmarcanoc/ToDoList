import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para escuchar los cambios en el estado de autenticación
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Registro con correo y contraseña
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error en el registro: ${e.toString()}');
      rethrow;
    }
  }

  // Inicio de sesión con correo y contraseña
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error en el inicio de sesión: ${e.toString()}');
      rethrow;
    }
  }

  // Inicio de sesión con Google
  Future<User?> signInWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      // Si el usuario cancela el inicio de sesión
      if (googleUser == null) return null;

      // Obtener los detalles de autenticación de la solicitud
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear una nueva credencial
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Una vez logados en Google, iniciamos sesión en Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error en el inicio de sesión con Google: ${e.toString()}');
      rethrow; // Lanzar para poder mostrar el error en la UI
    }
  }

  // Cerrar sesión general
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut(); // Cierra la sesión de la cuenta de Google (opcional pero bueno para resetear cuenta)
      return await _auth.signOut();   // Cierra la sesión en Firebase
    } catch (e) {
      print('Error al cerrar sesión: ${e.toString()}');
      rethrow;
    }
  }
}
