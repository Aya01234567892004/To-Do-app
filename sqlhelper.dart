import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        isComplete INTEGER
      )
    ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'todo.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createTask(
    String title,
    String description,
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'isComplete': 0,
    };

    return await db.insert(
      'tasks',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getTask(int id) async {
    final db = await SQLHelper.db();

    return await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await SQLHelper.db();

    return await db.query(
      'tasks',
      orderBy: 'id',
    );
  }

  static Future<int> updateTask(
    int id,
    String title,
    String description,
    int isComplete,
  ) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'isComplete': isComplete,
    };

    return await db.update(
      'tasks',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteTask(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      print("Error: $err");
    }
  }
}














