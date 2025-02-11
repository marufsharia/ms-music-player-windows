import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_tab_controllers/playlists_tab_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class PlaylistsTabView extends StatelessWidget {
  PlaylistsTabView({Key? key}) : super(key: key);

  final PlaylistsTabController controller = Get.put(PlaylistsTabController());
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final AudioService audioService = Get.find();
  final metadataService = MetadataService();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final playlists = controller.playlists;

      if (playlists.isEmpty) {
        return Center(
          child: Text(
            'No playlists created yet.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return ListTile(
            leading: const Icon(Icons.playlist_play),
            title: Text(playlist['name'] ?? 'Playlist'),
            onTap: () {
              _showPlaylistSongs(context, playlist['id']);
            },
          );
        },
      );
    });
  }

  void _showPlaylistSongs(BuildContext context, playlistId) async {
    List<Map<String, dynamic>> playlistSongs = await playlistController.getPlaylistSongs(playlistId);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: playlistSongs.length,
            itemBuilder: (context, index) {
              final song = playlistSongs[index]; // Use song data from playlistSongs
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
                title: Text(song['title'] ?? 'Unknown Title'),
                onTap: () async {
                  Navigator.pop(context); // Close bottom sheet
                  audioService.playSong(song); // Use playSong method from AudioService
                },
              );
            },
          ),
        );
      },
    );
  }
}