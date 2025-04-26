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
      CREATE TABLE task (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT
      );
    ''');
  }

  Future<int> insertTask(String title, String description) async {
    final db = await database;

    return await db.insert('task', {
      'title': title,
      'description': description,
      'isCompleted': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await database;
    return await db.query('task');
  }

  Future<int> updateTask(int id, Map<String, dynamic> taskData) async {
    final db = await database;
    return await db.update(
      'task',
      taskData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getCompleteTasks() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM task
      WHERE isCompleted = 1
  
    ''');
  }

  Future<List<Map<String, dynamic>>> getIncompleteTasks() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM task
      WHERE isCompleted = 0
    ''');
  }

  Future<int> insertNote(String content) async {
    final db = await database;
    return await db.insert('note', {'content': content});
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query('note');
  }

  Future<int> updateNote(int id, String content) async {
    final db = await database;
    return await db.update(
      'note',
      {'content': content},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('note', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'note',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}
