import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto/core/database/app_database.dart';
import 'package:projeto/features/registros/data/registro_dao.dart';
import 'package:projeto/features/registros/data/sqlite_registro_repository.dart';
import 'package:projeto/main.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('abre a tela de registros', (WidgetTester tester) async {
    final database = AppDatabase();
    final dao = RegistroDao(database);
    final repository = SqliteRegistroRepository(dao);

    await tester.pumpWidget(
      RegistroCampoApp(repository: repository),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(RegistroCampoApp), findsOneWidget);

    await database.close();
  });
}