import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String messagesTable = 'messages';

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  // Returns null on web — callers must handle the null case.
  Future<Database?> get database async {
    if (kIsWeb) return null;
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'timeexplorer.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $messagesTable (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        characterId TEXT    NOT NULL,
        role        TEXT    NOT NULL,
        content     TEXT    NOT NULL,
        timestamp   INTEGER NOT NULL
      )
    ''');
  }
}
