import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'core/auth/auth_service.dart';
import 'core/database/app_database.dart';
import 'features/registros/data/registro_dao.dart';
import 'features/registros/data/sqlite_registro_repository.dart';
import 'features/registros/domain/registro_repository.dart';
import 'features/registros/presentation/registro_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = AuthService(FirebaseAuth.instance);
  final usuario = await authService.garantirUsuario();

  debugPrint(
    'Sessão Firebase pronta: ${usuario.uid.substring(0, 6)}...',
  );

  final database = AppDatabase();
  final dao = RegistroDao(database);
  final repository = SqliteRegistroRepository(dao);

  runApp(
    RegistroCampoApp(repository: repository),
  );
}

class RegistroCampoApp extends StatelessWidget {
  const RegistroCampoApp({
    super.key,
    required this.repository,
  });

  final RegistroRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Campo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'RobotoUC13',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: RegistroListPage(
        repository: repository,
      ),
    );
  }
}