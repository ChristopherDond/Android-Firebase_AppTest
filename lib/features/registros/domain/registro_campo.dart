enum SituacaoRegistro {
  pendente,

  emAndamento,

  concluida,
}

enum StatusSincronizacao {
  pendente,

  sincronizado,

  erro,
}

class RegistroCampo {

  const RegistroCampo({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoriaId,
    required this.dataVisita,
    required this.situacao,
    required this.statusSincronizacao,
    required this.criadoEm,
    required this.atualizadoEm,
    this.categoriaNome,
    this.fotoPath,
    this.latitude,
    this.longitude,
  });

  final String id;

  final String titulo;

  final String descricao;

  final int categoriaId;

  final String? categoriaNome;

  final DateTime dataVisita;

  final SituacaoRegistro situacao;

  final String? fotoPath;

  final double? latitude;

  final double? longitude;

  final StatusSincronizacao statusSincronizacao;

  final DateTime criadoEm;

  final DateTime atualizadoEm;

  Map<String, Object?> toMap() {
    return {
      'id': id,

      'titulo': titulo.trim(),
      'descricao': descricao.trim(),

      'categoria_id': categoriaId,

      'data_visita': dataVisita.toUtc().toIso8601String(),

      'situacao': situacao.name,

      'foto_path': fotoPath,
      'latitude': latitude,
      'longitude': longitude,

      'status_sync': statusSincronizacao.name,

      'criado_em': criadoEm.toUtc().toIso8601String(),
      'atualizado_em': atualizadoEm.toUtc().toIso8601String(),
    };
  }

  factory RegistroCampo.fromMap(Map<String, Object?> map) {
    return RegistroCampo(
      id: map['id'] as String,
      titulo: map['titulo'] as String,

      descricao: map['descricao'] as String? ?? '',

      categoriaId: map['categoria_id'] as int,

      categoriaNome: map['categoria_nome'] as String?,

      dataVisita: DateTime.parse(
        map['data_visita'] as String,
      ).toLocal(),

      situacao: SituacaoRegistro.values.byName(
        map['situacao'] as String,
      ),

      fotoPath: map['foto_path'] as String?,

      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),

      statusSincronizacao: StatusSincronizacao.values.byName(
        map['status_sync'] as String,
      ),

      criadoEm: DateTime.parse(
        map['criado_em'] as String,
      ).toLocal(),

      atualizadoEm: DateTime.parse(
        map['atualizado_em'] as String,
      ).toLocal(),
    );
  }

  RegistroCampo copyWith({
    String? titulo,
    String? descricao,
    int? categoriaId,
    DateTime? dataVisita,
    SituacaoRegistro? situacao,
    StatusSincronizacao? statusSincronizacao,
    DateTime? atualizadoEm,
  }) {

    return RegistroCampo(

      id: id,

      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      categoriaId: categoriaId ?? this.categoriaId,

      categoriaNome: categoriaNome,
      dataVisita: dataVisita ?? this.dataVisita,
      situacao: situacao ?? this.situacao,
      fotoPath: fotoPath,
      latitude: latitude,
      longitude: longitude,

      statusSincronizacao:
      statusSincronizacao ?? this.statusSincronizacao,

      criadoEm: criadoEm,

      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}

extension SituacaoRegistroLabel on SituacaoRegistro {

  String get label {
    return switch (this) {
      SituacaoRegistro.pendente => 'Pendente',
      SituacaoRegistro.emAndamento => 'Em Andamento',
      SituacaoRegistro.concluida => 'Concluida',
    };
  }
}
