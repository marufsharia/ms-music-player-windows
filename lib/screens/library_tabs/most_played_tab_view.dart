import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_tab_controllers/most_played_tab_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class MostPlayedTabView extends StatelessWidget {
  MostPlayedTabView({Key? key}) : super(key: key);

  final MostPlayedTabController controller = Get.put(MostPlayedTabController());
  final PlaylistController playlistController = Get.find();
  final AudioService audioService = Get.find();
  final metadataService = MetadataService();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Theme.of(context);
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final mostPlayedSongs = controller.mostPlayedSongs;

      if (mostPlayedSongs.isEmpty) {
        return Center(
          child: Text(
            'No recently played songs.', // Adjust message based on your "most played" logic
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return ListView.builder(
        itemCount: mostPlayedSongs.length,
        itemBuilder: (context, index) {
          final song = mostPlayedSongs[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.play_arrow, // Adjust icon as needed
                color: themeProvider.colorScheme.primary,
              ),
            ),
            title: Text(song['title'] ?? 'Unknown Title'),
            subtitle: Text(song['artist'] ?? 'Unknown Artist'),
            onTap: () async {
              audioService.playSong(song); // Use playSong method from AudioService
            },
          );
        },
      );
    });
  }
}