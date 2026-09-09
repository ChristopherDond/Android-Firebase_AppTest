import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;

  String? get uid => _auth.currentUser?.uid;

  Stream<User?> get mudancas => _auth.authStateChanges();

  Future<User> garantirUsuario() async {
    final atual = _auth.currentUser;

    if (atual != null) {
      return atual;
    }

    final credencial = await _auth.signInAnonymously();
    final usuario = credencial.user;

    if (usuario == null) {
      throw StateError(
        'Firebase não retornou o usuário anônimo.',
      );
    }

    return usuario;
  }
}