import 'package:get/get.dart';
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

  Future<DatabaseService> initialize() async {
    try {
      await database;
      return this;
    } catch (e) {
      Get.log('Database initialization failed: $e');
      rethrow;
    }
  }


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

    await db.execute('CREATE INDEX idx_file_path ON media_files (file_path)');
    await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            artist TEXT,
            file_path TEXT UNIQUE
          )
        ''');
    await db.execute('''
          CREATE TABLE recent (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            artist TEXT,
            file_path TEXT,
            played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
    await db.execute('''
          CREATE TABLE playlists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE
          )
        ''');
    await db.execute('''
          CREATE TABLE playlist_songs (
            playlist_id INTEGER,
            song_path TEXT,
            FOREIGN KEY (playlist_id) REFERENCES playlists (id)
          )
        ''');

  }

  Future<void> addMediaFile(List<Map<String, dynamic>> songsToAdd) async {
    final db = await database;
    final validSongs = songsToAdd.where((s) => s['file_path'] != null).toList();
    for (var song in validSongs) {
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

  Future<List<Map<String, dynamic>>> getAllMediaFiles() async {
    final db = await database;
    return await db.query('media_files');
  }


  // Favorites

  Future<bool> isFavorite(String filePath) async {
    final db = await database;
    final result = await db.query('favorites', where: 'file_path = ?', whereArgs: [filePath]);
    return result.isNotEmpty;
  }

  Future<void> addToFavorites(Map<String, dynamic> song) async {
    final db = await database;
    await db.insert('favorites', song, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getFavoriteSongs() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT media_files.* 
    FROM favorites
    INNER JOIN media_files 
    ON favorites.file_path = media_files.file_path
  ''');
  }

  Future<void> removeFromFavorites(String filePath) async {
    final db = await database;
    await db.delete('favorites', where: 'file_path = ?', whereArgs: [filePath]);
  }

  // Recent
  Future <bool> isRecent (String filePath) async {
    final db = await database;
    final result = await db.query('recent', where: 'file_path = ?', whereArgs: [filePath]);
    return result.isNotEmpty;
  }

  Future<void> addRecentPlay(Map<String, dynamic> song) async {
    final db = await database;
    await db.insert('recent', {
      'file_path': song['file_path'],
      'title': song['title'],
      'artist': song['artist'],
      'played_at': DateTime.now().toIso8601String()
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getRecentPlayedSongs() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT media_files.*, recent.played_at
    FROM recent
    INNER JOIN media_files 
    ON recent.file_path = media_files.file_path
    ORDER BY recent.played_at DESC 
    LIMIT 20
  ''');
  }

  Future<void> removeRecentPlayed(String filePath) async {
    final db = await database;
    await db.delete('recent', where: 'file_path = ?', whereArgs: [filePath]);
  }



  // Playlists
  Future<void> createPlaylist(String name) async {
    final db = await database;
    await db.insert('playlists', {'name': name}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final db = await database;
    return await db.query('playlists');
  }

  Future<void> addSongToPlaylist(int playlistId, String songPath) async {
    final db = await database;
    await db.insert('playlist_songs', {'playlist_id': playlistId, 'song_path': songPath}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPlaylistSongs(int playlistId) async {
    final db = await database;
    return await db.query('playlist_songs', where: 'playlist_id = ?', whereArgs: [playlistId]);
  }
}
