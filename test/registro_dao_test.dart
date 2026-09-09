import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/core/database/app_database.dart';
import 'package:projeto/features/registros/data/registro_dao.dart';
import 'package:projeto/features/registros/domain/registro_campo.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AppDatabase database;
  late RegistroDao dao;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    database = AppDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );

    dao = RegistroDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('executa o ciclo completo de CRUD no SQLite', () async {
    final categorias = await dao.ListarCategorias();

    expect(categorias, isNotEmpty);

    final agora = DateTime.utc(2026, 8, 11, 14);

    final registro = RegistroCampo(
      id: 'uuid-crud',
      titulo: 'Inspeçao no laboratorio',
      descricao: 'Verificar tomadas e iluminaçao',
      categoriaId: categorias.first.id,
      dataVisita: agora,
      situacao: SituacaoRegistro.pendente,
      statusSincronizacao: StatusSincronizacao.pendente,
      criadoEm: agora,
      atualizadoEm: agora,
    );

    await dao.inserir(registro);

    var registros = await dao.Listar();

    expect(registros, hasLength(1));

    expect(registros.single.categoriaNome, isNotEmpty);

    expect(
      (await dao.buscarPorId(registro.id))?.titulo,
      registro.titulo,
    );

    final atualizado = registro.copyWith(
      titulo: 'Inspeçao concluida',
      situacao: SituacaoRegistro.concluida,
      atualizadoEm: agora.add(
        const Duration(minutes: 10),
      ),
    );

    await dao.atualizar(atualizado);

    registros = await dao.Listar();

    expect(
      registros.single.titulo,
      'Inspeçao concluida',
    );

    expect(
      registros.single.situacao,
      SituacaoRegistro.concluida,
    );

    await dao.remover(registro.id);

    expect(
      await dao.Listar(),
      isEmpty,
    );
  });
}