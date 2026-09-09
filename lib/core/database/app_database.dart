import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase({DatabaseFactory? factory, this.databasePath})
      : _factory = factory ?? databaseFactory;

  static const _databaseName = 'registro_campo.db';
  static const _databaseVersion = 2;

  final DatabaseFactory _factory;
  final String? databasePath;
  Database? _database;

  Future<Database> get database async {
    final openedDatabase = _database;

    if (openedDatabase != null && openedDatabase.isOpen) {
      return openedDatabase;
    }

    final resolvedPath =
        databasePath ?? path.join(await getDatabasesPath(), _databaseName);

    _database = await _factory.openDatabase(
      resolvedPath,
      options: OpenDatabaseOptions(
        version: _databaseVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE categorias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE
      )
    ''');

    batch.execute('''
      CREATE TABLE registros (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL DEFAULT '',
        categoria_id INTEGER NOT NULL,
        data_visita TEXT NOT NULL,
        situacao TEXT NOT NULL,
        foto_path TEXT,
        foto_url TEXT,
        latitude REAL,
        longitude REAL,
        removido INTEGER NOT NULL DEFAULT 0,
        status_sync TEXT NOT NULL DEFAULT 'pendente',
        criado_em TEXT NOT NULL,
        atualizado_em TEXT NOT NULL,
        FOREIGN KEY (categoria_id)
          REFERENCES categorias (id)
          ON UPDATE CASCADE
          ON DELETE RESTRICT
      )
    ''');

    batch.execute('CREATE INDEX idx_registros_data ON registros (data_visita)');
    batch.execute('CREATE INDEX idx_registros_sync ON registros (status_sync)');
    batch.execute('CREATE INDEX idx_registros_removido ON registros (removido)');

    for (final nome in const [
      'Inspeção',
      'Manutenção preventiva',
      'Manutenção corretiva',
      'Visita técnica',
    ]) {
      batch.insert('categorias', {'nome': nome});
    }

    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE registros ADD COLUMN foto_url TEXT',
      );

      await db.execute(
        'ALTER TABLE registros '
            'ADD COLUMN removido INTEGER NOT NULL DEFAULT 0',
      );

      await db.execute(
        'CREATE INDEX idx_registros_removido ON registros (removido)',
      );
    }
  }

  Future<void> close() async {
    final openedDatabase = _database;

    if (openedDatabase != null && openedDatabase.isOpen) {
      await openedDatabase.close();
    }

    _database = null;
  }
}