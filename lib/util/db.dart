import 'package:app_de_tarefas/models/model.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;

class DBUtil {
  static Future<sqlite.Database> _getDB() async {
    final databasePath = await sqlite.getDatabasesPath();
    final arqBD = path.join(databasePath, 'tarefas.db');

    return sqlite.openDatabase(
      arqBD,
      version: 2,
      onCreate: (db, version) => _criaTabela(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS Tarefa');
        await _criaTabela(db);
      },
    );
  }

  static Future<void> _criaTabela(sqlite.Database db) async {
    await db.execute('''
      CREATE TABLE Tarefa(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        dataPrevista TEXT NOT NULL,
        importante INTEGER NOT NULL,
        realizada INTEGER NOT NULL,
        categoria TEXT NOT NULL,
        ordem INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> insert(Model model) async {
    final db = await _getDB();
    model.id = await db.insert(model.runtimeType.toString(), model.toMap());
  }

  static Future<List<Map<String, dynamic>>> list(String table) async {
    final db = await _getDB();
    return db.query(table, orderBy: 'ordem ASC');
  }

  static Future<int> update(Model model) async {
    final db = await _getDB();
    return db.update(
      model.runtimeType.toString(),
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  static Future<int> delete(String table, int id) async {
    final db = await _getDB();
    return db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
