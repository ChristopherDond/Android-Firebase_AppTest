import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/registro_campo.dart';

abstract final class RegistroRemotoMapper {
  static Map<String, Object?> toFirestore(RegistroCampo r) => {
    'id': r.id,
    'titulo': r.titulo.trim(),
    'descricao': r.descricao.trim(),
    'categoriaId': r.categoriaId,
    'categoriaNome': r.categoriaNome,
    'dataVisita': Timestamp.fromDate(r.dataVisita.toUtc()),
    'situacao': r.situacao.name,
    'latitude': r.latitude,
    'longitude': r.longitude,
    'fotoUrl': r.fotoUrl,
    'criadoEm': Timestamp.fromDate(r.criadoEm.toUtc()),
    'atualizadoEm': Timestamp.fromDate(r.atualizadoEm.toUtc()),
    'removido': r.removido,
  };

  static RegistroCampo fromFirestore(Map<String, Object?> map) {
    DateTime data(String campo) =>
        (map[campo] as Timestamp).toDate().toLocal();

    return RegistroCampo(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String? ?? '',
      categoriaId: (map['categoriaId'] as num).toInt(),
      categoriaNome: map['categoriaNome'] as String?,
      dataVisita: data('dataVisita'),
      situacao: SituacaoRegistro.values.byName(
        map['situacao'] as String,
      ),
      fotoPath: null,
      fotoUrl: map['fotoUrl'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      statusSincronizacao: StatusSincronizacao.sincronizado,
      criadoEm: data('criadoEm'),
      atualizadoEm: data('atualizadoEm'),
      removido: map['removido'] as bool? ?? false,
    );
  }
}