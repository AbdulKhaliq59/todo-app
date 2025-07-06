import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/domain/models/todo_model.dart';

class TodoService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE todos (
            id TEXT PRIMARY KEY,
            title TEXT,
            description,
            isDone INTEGER,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTodo(TodoModel todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoModel>> fetchTodos() async {
    final db = await database;
    final maps = await db.query('todos');
    return maps.map((map) => TodoModel.fromMap(map)).toList();
  }

  Future<void> updateTodo(TodoModel todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(String id) async {
    final db = await database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
