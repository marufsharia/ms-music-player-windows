import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_tab_controllers/favorites_tab_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class FavoritesTabView extends StatelessWidget {
  FavoritesTabView({Key? key}) : super(key: key);

  final FavoritesTabController controller = Get.put(FavoritesTabController());
  final PlaylistController playlistController = Get.find();
  final AudioService audioService = Get.find();
  final metadataService = MetadataService();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final favoriteSongs = controller.favoriteSongs;

      if (favoriteSongs.isEmpty) {
        return Center(
          child: Text(
            'No favorite songs yet.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = favoriteSongs[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.primary,
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