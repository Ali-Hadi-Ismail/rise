import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE project (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL
    );
  ''');

    await db.execute('''
    CREATE TABLE task (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      projectId INTEGER,
      FOREIGN KEY (projectId) REFERENCES project(id) ON DELETE CASCADE
    );
  ''');

    await db.execute('''
    CREATE TABLE note (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT
    );
  ''');
  }

  Future<void> _insertProject(String title) async {
    final db = await database;
    await db.transaction((txt) async {
      await txt.rawInsert('''
     INSERT INTO project(content) VALUES(?)   
''', [title]);
    });
  }

  Future<void> _insertNote(String content) async {
    final db = await database;
    await db.transaction((txt) async {
      await txt.rawInsert('''
     INSERT INTO note(content) VALUES(?)   
''', [content]);
    });
  }

  Future<void> _insertTask(
      String title, String description, int projectId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO task(title, description, projectId) VALUES(?, ?, ?)',
        [title, description, projectId], // Values to be inserted
      );
    });
  }
}
