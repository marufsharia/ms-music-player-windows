import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/metadata_service.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:ms_music_player/widgets/player_controls.dart';
import 'package:ms_music_player/widgets/sidebar.dart';
import '../services/audio_service.dart';

class PlaylistPage extends StatefulWidget {
  PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final AudioService audioService = Get.find();
  final PlaylistController playlistController = Get.find();
  final metadataService = MetadataService();

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );
      if (result == null) return;

      final newSongs = await playlistController.processFiles(result.files);
      await playlistController.addSongsToDatabase(newSongs);

      if (newSongs.isNotEmpty) {
        await playlistController.loadAllSongs();
        audioService.loadAudioSource(0);
        await audioService.play();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add songs: ${e.toString()}');
    }
  }


  @override
  void initState() {
    super.initState();
   // playlistController.loadSongsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;
          int crossAxisCount = isWideScreen ? 6 : 2;

          return Column(
            children: [
              CustomAppBar(
                title: 'Playlist',
                isBackButtonVisible: true,
                onBackButtonPressed: () => Get.back(),
              ),
              Expanded(
                child: Row(
                  children: [
                    if (isWideScreen) Sidebar(audioService: audioService),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Manage your library",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Add songs to your playlist by selecting them from your device.",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await _pickFiles();
                                        },
                                        icon: const Icon(Icons.folder),
                                        label: const Text('Add Songs'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Obx(() {
                              return GridView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: playlistController.songs.length,
                                itemBuilder: (context, index) {
                                  final song = playlistController.songs[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      audioService.isLoading.value = true;
                                      //await audioService.loadAudioSource(index);
                                      await audioService.playSong(playlistController.songs[index]);
                                      //await audioService.play();
                                      audioService.isLoading.value = false;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[850],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: song['album_art'] != null
                                                  ? DecorationImage(
                                                image: song['album_art']?.isNotEmpty == true
                                                    ? FileImage(File(song['album_art']!))
                                                    : const AssetImage('assets/default_art.png') as ImageProvider,
                                                fit: BoxFit.cover,
                                                opacity: 0.9,
                                              )
                                                  : null,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.music_note,
                                                      size: 56,
                                                      color: Colors.black54),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Text(
                                                      song['title']!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (audioService.isLoading.value &&
                                              audioService.currentIndex.value ==
                                                  index)
                                            const Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 8),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                          PlayerControls(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
