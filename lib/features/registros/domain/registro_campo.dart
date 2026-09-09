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
    this.fotoUrl,
    this.latitude,
    this.longitude,
    this.removido = false,
  });

  final String id;
  final String titulo;
  final String descricao;
  final int categoriaId;
  final String? categoriaNome;
  final DateTime dataVisita;
  final SituacaoRegistro situacao;
  final String? fotoPath;
  final String? fotoUrl;
  final double? latitude;
  final double? longitude;
  final bool removido;
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
      'foto_url': fotoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'removido': removido ? 1 : 0,
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
      dataVisita: DateTime.parse(map['data_visita'] as String).toLocal(),
      situacao: SituacaoRegistro.values.byName(map['situacao'] as String),
      fotoPath: map['foto_path'] as String?,
      fotoUrl: map['foto_url'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      removido: (map['removido'] as int? ?? 0) == 1,
      statusSincronizacao: StatusSincronizacao.values.byName(
        map['status_sync'] as String,
      ),
      criadoEm: DateTime.parse(map['criado_em'] as String).toLocal(),
      atualizadoEm: DateTime.parse(map['atualizado_em'] as String).toLocal(),
    );
  }

  RegistroCampo copyWith({
    String? titulo,
    String? descricao,
    int? categoriaId,
    DateTime? dataVisita,
    SituacaoRegistro? situacao,
    String? fotoPath,
    String? fotoUrl,
    double? latitude,
    double? longitude,
    bool? removido,
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
      fotoPath: fotoPath ?? this.fotoPath,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      removido: removido ?? this.removido,
      statusSincronizacao: statusSincronizacao ?? this.statusSincronizacao,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}

extension SituacaoRegistroLabel on SituacaoRegistro {
  String get label {
    return switch (this) {
      SituacaoRegistro.pendente => 'Pendente',
      SituacaoRegistro.emAndamento => 'Em andamento',
      SituacaoRegistro.concluida => 'Concluída',
    };
  }
}