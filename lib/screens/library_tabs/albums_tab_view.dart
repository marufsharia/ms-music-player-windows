import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_tab_controllers/albums_tab_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class AlbumsTabView extends StatelessWidget {
  AlbumsTabView({Key? key}) : super(key: key);

  final AlbumsTabController controller = Get.put(AlbumsTabController());
  final PlaylistController playlistController = Get.find();
  final AudioService audioService = Get.find();
  final metadataService = MetadataService();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final albums = controller.albums;
      final albumMap = controller.albumMap;

      if (albums.isEmpty) {
        return Center(
          child: Text(
            'No media files found in library.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final albumName = albums[index];
          final albumFiles = albumMap[albumName] ?? [];
          return ListTile(
            leading: const Icon(Icons.album),
            title: Text(albumName),
            subtitle: Text('${albumFiles.length} songs'),
            onTap: () {
              _showAlbumSongs(context, albumFiles);
            },
          );
        },
      );
    });
  }

  void _showAlbumSongs(BuildContext context, List<String> albumFiles) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: albumFiles.length,
            itemBuilder: (context, index) {
              final filePath = albumFiles[index];
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