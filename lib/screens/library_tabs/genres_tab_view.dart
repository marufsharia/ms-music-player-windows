import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_tab_controllers/genres_tab_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class GenresTabView extends StatelessWidget {
  GenresTabView({Key? key}) : super(key: key);

  final GenresTabController controller = Get.put(GenresTabController());
  final PlaylistController playlistController = Get.find();
  final AudioService audioService = Get.find();
  final metadataService = MetadataService();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final genres = controller.genres;
      final genreMap = controller.genreMap;

      if (genres.isEmpty) {
        return Center(
          child: Text(
            'No media files found in library.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genreName = genres[index];
          final genreFiles = genreMap[genreName] ?? [];
          return ListTile(
            leading: const Icon(Icons.music_note), // Generic icon for genres
            title: Text(genreName),
            subtitle: Text('${genreFiles.length} songs'),
            onTap: () {
              _showGenreSongs(context, genreFiles);
            },
          );
        },
      );
    });
  }

  void _showGenreSongs(BuildContext context, List<String> genreFiles) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: genreFiles.length,
            itemBuilder: (context, index) {
              final filePath = genreFiles[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(filePath.split('/').last),
                onTap: () async {
                  Navigator.pop(context); // Close bottom sheet
                  final metadata = await metadataService.extractMetadata(filePath);
                  final albumArtPath = await metadataService.extractAlbumArt(filePath);
                  List<Map<String, dynamic>> newSongs = [];
                  newSongs.add({
                    'title': metadata['title'] ?? 'Unknown Title',
                    'artist': metadata['artist'] ?? 'Unknown Artist',
                    'album': metadata['album'] ?? 'Unknown Album',
                    'duration': metadata['duration'] ?? '00:00',
                    'album_art': albumArtPath ?? '',
                    'file_path': filePath,
                  });
                  playlistController.addSongsToDatabase(newSongs);
                  audioService.player.setAudioSource(
                    AudioSource.uri(Uri.file(filePath)),
                    initialIndex: index,
                    preload: true,
                  );
                  audioService.play();
                  Get.log('File Path: $filePath');
                },
              );
            },
          ),
        );
      },
    );
  }
}