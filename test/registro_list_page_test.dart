import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/features/registros/domain/categoria.dart';
import 'package:projeto/features/registros/domain/registro_campo.dart';
import 'package:projeto/features/registros/domain/registro_repository.dart';
import 'package:projeto/main.dart';

void main() {
  testWidgets(
    'apresenta o estado vazio quando não existem registros',
        (tester) async {
      await tester.pumpWidget(
        RegistroCampoApp(
          repository: _RepositorioVazio(),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Nenhum registro cadastrado'),
        findsOneWidget,
      );

      expect(
        find.text('Criar registro'),
        findsOneWidget,
      );
    },
  );
}

class _RepositorioVazio implements RegistroRepository {
  @override
  Future<RegistroCampo?> buscarPorId(String id) async {
    return null;
  }

  @override
  Future<List<RegistroCampo>> listar() async {
    return const [];
  }

  @override
  Future<List<Categoria>> listarCategorias() async {
    return const [
      Categoria(
        id: 1,
        nome: 'Inspeção',
      ),
    ];
  }

  @override
  Future<void> atualizar(RegistroCampo registro) async {}

  @override
  Future<void> inserir(RegistroCampo registro) async {}

  @override
  Future<void> remover(String id) async {}
}