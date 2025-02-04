import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

class PlaylistController extends GetxController {
  final RxList<Map<String, String>> songs = <Map<String, String>>[].obs;
    Database? _db;

  @override
  void onInit() async{
    super.onInit();
   await _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'playlist.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS playlist (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_path TEXT UNIQUE NOT NULL,
            title TEXT,
            artist TEXT,
            album TEXT
          )
        ''');
      },
    );
    await loadSongsFromDatabase();
  }

  Future<void> loadSongsFromDatabase() async {
    if (_db == null) return; // ✅ Ensure database is initialized

    try {
      final records = await _db!.query('playlist');
      songs.assignAll(records.map(_convertRecord).toList());
    } catch (e) {
      Get.snackbar("Error", "Failed to load songs: ${e.toString()}");
    }
  }

  Map<String, String> _convertRecord(Map<String, dynamic> record) {
    return {
      'path': record['file_path'] as String,
      'title': record['title'] as String? ?? 'Unknown Title',
      'artist': record['artist'] as String? ?? 'Unknown Artist',
      'album': record['album'] as String? ?? 'Unknown Album',
    };
  }

  Future<List<Map<String, String>>> processFiles(List<PlatformFile> files) async {
    List<Map<String, String>> newSongs = [];

    for (final file in files) {
      if (file.path == null) continue;

      newSongs.add({
        'path': file.path!,
        'title': file.name,  // Metadata পার্সিং এখন বাদ দেওয়া হয়েছে
        'artist': "Unknown Artist",
        'album': "Unknown Album",
      });
    }

    return newSongs;
  }

  Future<void> addSongsToDatabase(List<Map<String, String>> songsData) async {
    final batch = _db?.batch();
    for (final song in songsData) {
      batch?.insert(
        'playlist',
        {
          'file_path': song['path'],
          'title': song['title'],
          'artist': song['artist'],
          'album': song['album'],
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch?.commit();
    songs.addAll(songsData);
    loadSongsFromDatabase();
  }

  Future<void> removeSong(int index) async {
    if (index < 0 || index >= songs.length) return;

    try {
      await _db!.delete(
        'playlist',
        where: 'file_path = ?',
        whereArgs: [songs[index]['path']],
      );
      songs.removeAt(index);
    } catch (e) {
      Get.snackbar("Error", "Failed to remove song: ${e.toString()}");
    }
  }

  @override
  void onClose() {
    _db!.close();
    super.onClose();
  }
}
