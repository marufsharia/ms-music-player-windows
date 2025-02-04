import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/playlist_model.dart';

class PlaylistDB {
  static final PlaylistDB _instance = PlaylistDB._internal();
  static Database? _database;

  PlaylistDB._internal();

  factory PlaylistDB() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'playlist.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE playlists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> addPlaylist(Playlist playlist) async {
    final db = await database;
    return await db.insert('playlists', playlist.toMap());
  }

  Future<List<Playlist>> fetchPlaylists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('playlists');
    return List.generate(maps.length, (i) => Playlist.fromMap(maps[i]));
  }

  Future<int> deletePlaylist(int id) async {
    final db = await database;
    return await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
  }
}
