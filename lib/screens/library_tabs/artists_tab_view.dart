import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_tab_controllers/artists_tab_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class ArtistsTabView extends StatelessWidget {
  ArtistsTabView({Key? key}) : super(key: key);

  final ArtistsTabController controller = Get.put(ArtistsTabController());
  final PlaylistController playlistController = Get.find();
  final AudioService audioService = Get.find();
  final metadataService = MetadataService();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final artists = controller.artists;
      final artistMap = controller.artistMap;

      if (artists.isEmpty) {
        return Center(
          child: Text(
            'No media files found in library.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return ListView.builder(
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artistName = artists[index];
          final artistFiles = artistMap[artistName] ?? [];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(artistName),
            subtitle: Text('${artistFiles.length} songs'),
            onTap: () {
              _showArtistSongs(context, artistFiles);
            },
          );
        },
      );
    });
  }

  void _showArtistSongs(BuildContext context, List<String> artistFiles) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: artistFiles.length,
            itemBuilder: (context, index) {
              final filePath = artistFiles[index];
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