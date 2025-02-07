import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'media_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
    CREATE TABLE media_files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        artist TEXT,
        album TEXT,
        duration TEXT,
        album_art TEXT,
        file_path TEXT UNIQUE
      )''',
    );
  }

  Future<void> addMediaFile(List<Map<String, dynamic>> songsToAdd) async {
    final db = await database;
    for (var song in songsToAdd) {
      await db.insert(
        'media_files',
        {
          'title': song['title'],
          'artist': song['artist'],
          'album': song['album'],
          'duration': song['duration'],
          'album_art': song['album_art'],
          'file_path': song['file_path'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


  Future<void> deleteMediaFile(String filePath) async {
    final db = await database;
    await db.delete(
      'media_files',
      where: 'path = ?',
      whereArgs: [filePath],
    );
  }

  Future<List<String>> getAllMediaFiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('media_files');

    return List<String>.from(maps.map((map) => map['path']));
  }
}
