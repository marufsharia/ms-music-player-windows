import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/services/metadata_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
class PlaylistController extends GetxController {
 var _db;
  final RxList<Map<String, dynamic>> songs = <Map<String, dynamic>>[].obs;
  final metadataService = MetadataService();

  @override
  void onInit() {
    super.onInit();
    _initDatabase();
  }

 Future<void> _initDatabase() async {
   var databaseFactory = databaseFactoryFfi;
   _db = await databaseFactory.openDatabase(inMemoryDatabasePath);

   try {
     await _db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        artist TEXT,
        album TEXT,
        duration TEXT,
        album_art TEXT,
        file_path TEXT UNIQUE
      );
    ''');

     print("✅ Database initialized successfully!");
   } catch (e) {
     print("❌ Database initialization failed: $e");
   }
 }

   Future<List<Map<String, dynamic>>> processFiles(List<PlatformFile> files) async {
     List<Map<String, dynamic>> newSongs = [];

     for (var file in files) {
       if (file.path == null) {
         print("❌ Skipping file: No path available");
         continue;
       }

       String filePath = file.path!;
       final metadata = await metadataService.extractMetadata(filePath);
       final albumArtPath = await metadataService.extractAlbumArt(filePath);

       newSongs.add({
         'title': metadata['title'] ?? 'Unknown Title',
         'artist': metadata['artist'] ?? 'Unknown Artist',
         'album': metadata['album'] ?? 'Unknown Album',
         'duration': metadata['duration'] ?? '00:00',
         'album_art': albumArtPath ?? '',
         'file_path': filePath,
       });
     }

     return newSongs;
   }


  Future<void> addSongsToDatabase(List<Map<String, dynamic>> songsToAdd) async {
    if (_db == null) return; // Prevent crash
    for (var song in songsToAdd) {
      await _db?.insert('songs', song, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    loadSongsFromDatabase();
  }

  Future<void> loadSongsFromDatabase() async {
    if (_db == null) return; // Prevent crash
    final List<Map<String, dynamic>> dbSongs = await _db?.query('songs');
    songs.assignAll(dbSongs);
  }

  Future<void> removeSong(int index) async {
    if (_db == null) return; // Prevent crash
    await _db?.delete('songs', where: 'id = ?', whereArgs: [songs[index]['id']]);
    songs.removeAt(index);
  }

  @override
  void onClose() {
    _db?.close();
    super.onClose();
  }
}
