import 'package:firebase_auth/firebase_auth.dart';
import '../model/usuario.dart';

class LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Usuario?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = credential.user;
      if (user == null) return null; // Garante que user não é nulo

      return Usuario(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'Usuário',
      );
    } on FirebaseAuthException catch (e) {
      print('Erro ao fazer login: ${e.message}'); // Log do erro
      return null;
    } catch (e) {
      print('Erro inesperado: $e');
      return null;
    }
  }
}
