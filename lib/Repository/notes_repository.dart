import 'dart:ui';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/note.dart';

class NotesRepository {
  static const _dbName = 'my_notes.db';
  static const _tableName = 'notes';

  static Future<Database> _database() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, title TEXT, '
              'noteDescription TEXT, createdAt TEXT)',
        );
      },
    );

    await _addMissingColumns(database);

    return database;
  }

  static Future<void> _addMissingColumns(Database db) async {
    final columns = [
      {'name': 'fontSize', 'type': 'REAL', 'default': '16.0'},
      {'name': 'fontColor', 'type': 'INTEGER', 'default': '4278190080'},
      {'name': 'isBold', 'type': 'INTEGER', 'default': '0'},
      {'name': 'isItalic', 'type': 'INTEGER', 'default': '0'},
      {'name': 'isUnderline', 'type': 'INTEGER', 'default': '0'},
    ];

    for (var column in columns) {
      try {
        await db.execute(
          'ALTER TABLE $_tableName ADD COLUMN ${column['name']} ${column['type']} DEFAULT ${column['default']}',
        );
      } catch (e) {
      }
    }
  }

  static insert({required Note note}) async {
    final db = await _database();
    await db.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Note>> getNotes() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        noteDescription: maps[i]['noteDescription'] as String,
        createdAt: DateTime.parse(maps[i]['createdAt']),
        fontSize: maps[i]['fontSize'] as double? ?? 16.0,
        fontColor: Color(maps[i]['fontColor'] as int? ?? 4278190080), // Convert int to Color
        isBold: (maps[i]['isBold'] as int? ?? 0) == 1,
        isItalic: (maps[i]['isItalic'] as int? ?? 0) == 1,
        isUnderline: (maps[i]['isUnderline'] as int? ?? 0) == 1,
      );
    });
  }


  static update({required Note note}) async {
    final db = await _database();
    await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static delete({required Note note}) async {
    final db = await _database();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
