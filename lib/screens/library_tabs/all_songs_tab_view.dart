import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_tab_controllers/all_songs_tab_controller.dart'; // Import Controller
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class AllSongsTabView extends StatelessWidget { // StatelessWidget now
 // var songs=[];
  AllSongsTabView({Key? key}) : super(key: key);

  final AllSongsTabController allSongController = Get.put(AllSongsTabController()); // Put Controller
  final PlaylistController playlistController = Get.find();
  final AudioService audioService = Get.find();
  final metadataService = MetadataService();

  @override
  Widget build(BuildContext context) {
    return Obx(() { // Use Obx to react to allSongController state
      if (allSongController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final mediaFiles = allSongController.mediaFiles;
     // Get.log("AllSongsTabView: build() - Media files count: ${mediaFiles.length}"); // Added log
      if (mediaFiles.isEmpty) {
        return Center(
          child: Text(
            'No media files found in library.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return ListView.separated(
        itemCount: mediaFiles.length,
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).dividerColor,
          height: 1,
        ),
        itemBuilder: (context, index) {
          final filePath = mediaFiles[index];
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
            title: Text(
              filePath.split('/').last,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              filePath,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
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
      );
    });
  }
}