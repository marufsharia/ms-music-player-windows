import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_tab_controllers/recommended_tab_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class RecommendedTabView extends StatelessWidget {
  RecommendedTabView({Key? key}) : super(key: key);

  final RecommendedTabController controller = Get.put(RecommendedTabController());
  final PlaylistController playlistController = Get.find();
  final AudioService audioService = Get.find();
  final metadataService = MetadataService();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final recommendedSongs = controller.recommendedSongs;

      if (recommendedSongs.isEmpty) {
        return const Center(
          child: Text(
            'No recommendations available yet.', // Or "Recommendations loading..."
          ),
        );
      }

      return ListView.builder(
        itemCount: recommendedSongs.length,
        itemBuilder: (context, index) {
          final song = recommendedSongs[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.star, // Or a different icon for recommendations
                color: Colors.amber,
              ),
            ),
            title: Text(song['title'] ?? 'Recommended Song'),
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