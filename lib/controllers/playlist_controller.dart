import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ms_music_player/services/database_service.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class PlaylistController extends GetxController {

  final metadataService = MetadataService();
  RxList<Map<String, dynamic>> songs = <Map<String, dynamic>>[].obs;
  final DatabaseService _dbService = Get.find();
  final isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    await loadAllSongs();
    super.onReady();
  }


  Future<List<Map<String, dynamic>>> processFiles(
      List<PlatformFile> files) async {
    List<Map<String, dynamic>> newSongs = [];

    for (var file in files) {
      if (file.path == null) {
        print("❌ Skipping file: No path available");
        continue;
      }

      String filePath = file.path!;
      final metadata = await metadataService.extractMetadata(filePath);
      final albumArtPath = await metadataService.extractAlbumArt(filePath);
      // Add to database with proper structure
      await _dbService.addMediaFile([{
        'title': metadata['title'] ?? 'Unknown Title',
        'artist': metadata['artist'] ?? 'Unknown Artist',
        'album': metadata['album'] ?? 'Unknown Album',
        'duration': metadata['duration']?.toString() ?? '0:00',
        'album_art': albumArtPath ?? '',
        'file_path': filePath
      }]);
    }

    return newSongs;
  }

  Future<void> loadAllSongs() async {
    isLoading.value = true;
    songs.value = await _dbService.getAllMediaFiles();
    isLoading.value = false;
  }

  //add single song to database as player playlist queue
  Future<void> addSongsToDatabase(List<Map<String, dynamic>> songsToAdd) async {
    await _dbService.addMediaFile(songsToAdd);
    await loadAllSongs();
  }




  /*Future<void> removeSong(int index) async {
    if (_dbService == null) return; // Prevent crash
    _dbService?.delete('songs', where: 'id = ?', whereArgs: [songs[index]['id']]);
    songs.removeAt(index);
  }*/


  Future<void> createPlaylist(String name) async {
    await _dbService.createPlaylist(name);
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    return await _dbService.getPlaylists();
  }

  Future<void> addSongToPlaylist(int playlistId, String songPath) async {
    await _dbService.addSongToPlaylist(playlistId, songPath);
  }

  Future<List<Map<String, dynamic>>> getPlaylistSongs(int playlistId) async {
    return await _dbService.getPlaylistSongs(playlistId);
  }

  Future<void> addRecording(String filePath) async {
    // Extract metadata from the recording
    final metadata = {
      'title': 'Recording ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
      'artist': 'User',
      'album': 'Recordings',
      'duration': '0:00', // You can calculate this later
      'album_art': '', // Add a default recording icon path
      'file_path': filePath,
    };

    // Add to database
    await _dbService.addMediaFile([metadata]);

    // Refresh the playlist
    await loadAllSongs();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
