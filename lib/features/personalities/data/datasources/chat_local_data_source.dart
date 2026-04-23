import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/message_model.dart';

class ChatLocalDataSource {
  static const int _messageLimit = 50;
  static const String _prefPrefix = 'chat_messages_';

  // ── Public API ──────────────────────────────────────────────────────────────

  Future<void> insertMessage(MessageModel message) async {
    if (kIsWeb) {
      await _webInsert(message);
    } else {
      await _nativeInsert(message);
    }
  }

  Future<List<MessageModel>> getMessagesByCharacter(String characterId) async {
    if (kIsWeb) {
      return _webGet(characterId);
    } else {
      return _nativeGet(characterId);
    }
  }

  Future<void> clearMessages(String characterId) async {
    if (kIsWeb) {
      await _webClear(characterId);
    } else {
      await _nativeClear(characterId);
    }
  }

  // ── Web path — SharedPreferences + JSON ─────────────────────────────────────

  Future<void> _webInsert(MessageModel message) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefPrefix${message.characterId}';
    final raw = prefs.getStringList(key) ?? [];
    raw.add(jsonEncode(message.toMap()));
    if (raw.length > _messageLimit) {
      raw.removeRange(0, raw.length - _messageLimit);
    }
    await prefs.setStringList(key, raw);
  }

  Future<List<MessageModel>> _webGet(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('$_prefPrefix$characterId') ?? [];
    return raw
        .map((e) => MessageModel.fromMap(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _webClear(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefPrefix$characterId');
  }

  // ── Native path — sqflite ────────────────────────────────────────────────────

  Future<void> _nativeInsert(MessageModel message) async {
    final db = await DatabaseHelper.instance.database;
    if (db == null) return;
    await db.insert(DatabaseHelper.messagesTable, message.toMap());
    await _enforceLimit(db, message.characterId);
  }

  Future<List<MessageModel>> _nativeGet(String characterId) async {
    final db = await DatabaseHelper.instance.database;
    if (db == null) return [];
    final maps = await db.query(
      DatabaseHelper.messagesTable,
      where: 'characterId = ?',
      whereArgs: [characterId],
      orderBy: 'timestamp ASC',
    );
    return maps.map(MessageModel.fromMap).toList();
  }

  Future<void> _nativeClear(String characterId) async {
    final db = await DatabaseHelper.instance.database;
    if (db == null) return;
    await db.delete(
      DatabaseHelper.messagesTable,
      where: 'characterId = ?',
      whereArgs: [characterId],
    );
  }

  Future<void> _enforceLimit(Database db, String characterId) async {
    final rows = await db.rawQuery(
      'SELECT COUNT(*) as c FROM ${DatabaseHelper.messagesTable} WHERE characterId = ?',
      [characterId],
    );
    final count = rows.first['c'] as int? ?? 0;
    if (count <= _messageLimit) return;

    final excess = count - _messageLimit;
    await db.execute(
      'DELETE FROM ${DatabaseHelper.messagesTable} WHERE characterId = ? AND id IN '
      '(SELECT id FROM ${DatabaseHelper.messagesTable} WHERE characterId = ? '
      'ORDER BY timestamp ASC LIMIT ?)',
      [characterId, characterId, excess],
    );
  }
}
