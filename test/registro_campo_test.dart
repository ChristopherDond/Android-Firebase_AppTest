import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/features/registros/domain/registro_campo.dart';

void main() {
  test('converte RegistroCampo para Map e reconstrui o objeto', () {
    final criadoEm = DateTime.utc(2026, 8, 11, 12);

    final registro = RegistroCampo(
      id: '1',
      titulo: 'Inspeção elétrica',
      descricao: 'Verificar o quadro do laboratório.',
      categoriaId: 1,
      dataVisita: DateTime.utc(2026, 8, 13),
      situacao: SituacaoRegistro.pendente,
      statusSincronizacao: StatusSincronizacao.pendente,
      criadoEm: criadoEm,
      atualizadoEm: criadoEm,
    );

    final reconstruido = RegistroCampo.fromMap(registro.toMap());

    expect(reconstruido.id, registro.id);
    expect(reconstruido.titulo, registro.titulo);
    expect(reconstruido.categoriaId, 1);
    expect(
      reconstruido.situacao,
      SituacaoRegistro.pendente,
    );

    expect(
      reconstruido.dataVisita.toUtc().toIso8601String(),
      registro.dataVisita.toUtc().toIso8601String(),
    );

    expect(
      reconstruido.criadoEm.toUtc().toIso8601String(),
      registro.criadoEm.toUtc().toIso8601String(),
    );
    expect(
      reconstruido.atualizadoEm.toUtc().toIso8601String(),
      registro.atualizadoEm.toUtc().toIso8601String(),
    );
  });
}