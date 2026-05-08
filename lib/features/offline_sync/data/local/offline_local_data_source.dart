import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/offline_record.dart';
import '../models/offline_record_model.dart';

class OfflineLocalDataSource {
  static const _dbName = 'offline_sync.db';
  static const _table = 'offline_records';

  Database? _db;

  Future<Database?> get _database async {
    if (kIsWeb) return null;
    _db ??= await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int _) async {
    await db.execute('''
      CREATE TABLE $_table (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        type      TEXT    NOT NULL,
        data      TEXT    NOT NULL,
        isSynced  INTEGER NOT NULL DEFAULT 0,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertData(OfflineRecord record) async {
    final db = await _database;
    if (db == null) return -1;
    final model = OfflineRecordModel(
      type: record.type,
      data: record.data,
      isSynced: false,
      timestamp: record.timestamp,
    );
    return db.insert(_table, model.toMap());
  }

  Future<List<OfflineRecordModel>> fetchUnsyncedData() async {
    final db = await _database;
    if (db == null) return [];
    final rows = await db.query(
      _table,
      where: 'isSynced = ?',
      whereArgs: [0],
      orderBy: 'timestamp ASC',
    );
    return rows.map(OfflineRecordModel.fromMap).toList();
  }

  Future<void> markAsSynced(int id) async {
    final db = await _database;
    if (db == null) return;
    await db.update(
      _table,
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteRecord(int id) async {
    final db = await _database;
    if (db == null) return;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
