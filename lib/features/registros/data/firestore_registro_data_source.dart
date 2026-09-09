import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/auth/auth_service.dart';
import '../domain/registro_campo.dart';
import 'registro_remote_mapper.dart';

class FirestoreRegistroDataSource {
  FirestoreRegistroDataSource(
      this._firestore,
      this._authService,
      );

  final FirebaseFirestore _firestore;
  final AuthService _authService;

  CollectionReference<Map<String, dynamic>> get _registros {
    final uid = _authService.uid;

    if (uid == null) {
      throw StateError('Usuário não autenticado.');
    }

    return _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('registros');
  }

  Future<void> enviar(RegistroCampo registro) async {
    await _registros.doc(registro.id).set(
      RegistroRemoteMapper.toFirestore(registro),
      SetOptions(merge: true),
    );
  }

  Future<void> remover(String id) {
    return _registros.doc(id).delete();
  }

  Future<List<RegistroCampo>> listar() async {
    final snapshot = await _registros.orderBy('atualizadoEm').get();

    return snapshot.docs
        .map(
          (doc) => RegistroRemoteMapper.fromFirestore(
        doc.data(),
      ),
    )
        .toList();
  }
}