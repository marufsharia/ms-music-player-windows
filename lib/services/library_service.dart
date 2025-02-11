import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/services/metadata_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/services/database_service.dart';
import 'package:ms_music_player/controllers/library_controller.dart';

class LibraryManager extends GetxService {
  final DatabaseService _dbService = DatabaseService();
  final LibraryController _libraryController = Get.find();
  final PlaylistController playlistController = Get.find();
  final metadataService = MetadataService();
  final AudioService audioService = Get.find();

  static final LibraryManager _instance = LibraryManager._internal();

  factory LibraryManager() {
    return _instance;
  }

  LibraryManager._internal();

  static LibraryManager get instance => _instance;

  /// Scans the default music and video directories
  Future<void> scanDefaultFolders() async {
    List<String> defaultFolders = await _getDefaultMediaFolders();
    for (String folder in defaultFolders) {
      await _scanFolder(folder);
    }
  }

  /// Allows user to pick a custom folder and scan it
  Future<void> addCustomFolder(BuildContext context) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      await _scanFolder(selectedDirectory);
    }
  }

  /// Scans a given folder and adds media files to the database
  Future<void> _scanFolder(String folderPath) async {
    Directory directory = Directory(folderPath);
    try {
      _libraryController.startLoading();
      List<FileSystemEntity> files = directory.listSync(recursive: true);
      List<Map<String, dynamic>> newSongs = [];
      for (FileSystemEntity file in files) {
        if (file is File && _isMediaFile(file.path)) {
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
      }

     // Get.log("LibraryManager: _scanFolder() - Found ${newSongs.length} new songs in folder: $folderPath"); // Added log
      if (newSongs.isNotEmpty) {
        await _dbService.addMediaFile(newSongs);
       // Get.log("LibraryManager: _scanFolder() - Added ${newSongs.length} songs to database."); // Added log
        await playlistController.addSongsToDatabase(newSongs); // Keep this for playlist queue
      }

    } catch (e) {
      Get.log('Error scanning folder: $e');
    } finally {
      _libraryController.stopLoading();
    }
  }

  /// Returns default media folders
  Future<List<String>> _getDefaultMediaFolders() async {
    Directory? musicDir = await getMusicDirectory();
    Directory? videoDir = await getVideoDirectory();
    return [
      if (musicDir != null) musicDir.path,
      if (videoDir != null) videoDir.path
    ];
  }

  /// Placeholder for getting the music directory
  Future<Directory?> getMusicDirectory() async {
    // Placeholder implementation using getApplicationDocumentsDirectory
    return await getApplicationDocumentsDirectory();
  }

  /// Placeholder for getting the video directory
  Future<Directory?> getVideoDirectory() async {
    // Placeholder implementation using getApplicationDocumentsDirectory
    return await getApplicationDocumentsDirectory();
  }

  /// Retrieves all media files from the database
  Future<List<String>> getAllMediaFiles() async {
    Get.log("LibraryManager: getAllMediaFiles() - Fetching media files from database..."); // Added log
    final dbFiles = await _dbService.getAllMediaFiles();
    final filePaths = dbFiles
        .map((map) => map['file_path']?.toString() ?? '')
        .where((path) => path.isNotEmpty)
        .toList();
    Get.log("LibraryManager: getAllMediaFiles() - Fetched ${filePaths.length} media files from database."); // Added log
    return filePaths;
  }

  /// Checks if a file is a media file
  bool _isMediaFile(String path) {
    return path.endsWith('.mp3') ||
        path.endsWith('.wav') ||
        path.endsWith('.flac') ||
        path.endsWith('.mp4') ||
        path.endsWith('.avi') ||
        path.endsWith('.mkv');
  }
}