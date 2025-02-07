import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/route/route_manager.dart';
import 'package:ms_music_player/services/metadata_service.dart';
import 'package:ms_music_player/widgets/player_controls.dart';

import '../controllers/playlist_controller.dart';
import '../services/audio_service.dart';

class PlaylistPage extends StatefulWidget {
  PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final AudioService audioService = Get.put(AudioService());

  final PlaylistController playlistController = Get.put(PlaylistController());
  final metadataService = MetadataService();

  void _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result == null) return;

      final newSongs = await playlistController.processFiles(result.files);

      await playlistController.addSongsToDatabase(newSongs);
      if (newSongs.isNotEmpty) {
        audioService.loadAudioSource(0);
        audioService.play();
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    playlistController.loadSongsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Playlists"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _pickFiles,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Container(
                width: constraints.maxWidth < 600 ? 100 : 200,
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DrawerHeader(
                      child: Text(
                        "MS Music",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home, color: Colors.white),
                      title: Text("Home", style: TextStyle(color: Colors.white)),
                      onTap: () => Get.toNamed(Routes.musicPlayerHome),
                    ),
                    ListTile(
                      leading: Icon(Icons.library_music, color: Colors.white),
                      title: Text("Library", style: TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      leading: Icon(Icons.playlist_play, color: Colors.white),
                      title: Text("Playlists", style: TextStyle(color: Colors.white)),
                      onTap: () => Get.log("Playlists"),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.white),
                      title: Text("Settings", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Obx(
                            () => GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: constraints.maxWidth < 600 ? 2 : 6,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: playlistController.songs.length,
                          itemBuilder: (context, index) {
                            final song = playlistController.songs[index];

                            return GestureDetector(
                              onLongPress: () {
                                Get.defaultDialog(
                                  title: "Delete Song",
                                  middleText: "Are you sure you want to delete ${song['title']!}?",
                                  textConfirm: "Delete",
                                  textCancel: "Cancel",
                                  confirmTextColor: Colors.white,
                                  onConfirm: () {
                                    playlistController.removeSong(index);
                                    Get.back();
                                  },
                                );
                              },
                              onTap: () async {
                                audioService.isLoading.value = true;
                                await audioService.loadAudioSource(index);
                                await audioService.play();
                                audioService.isLoading.value = false;
                              },
                              child: Expanded(
                                child: Obx(() {
                                  return Stack(
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: song['album_art'] != null && song['album_art']!.isNotEmpty
                                                ? null
                                                : Colors.blueGrey[300],
                                            borderRadius: BorderRadius.circular(12),
                                            image: song['album_art'] != null && song['album_art']!.isNotEmpty
                                                ? DecorationImage(
                                              image: FileImage(File(song['album_art']!)),
                                              fit: BoxFit.cover,
                                              opacity: 0.9,
                                            )
                                                : null,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.music_note, size: 56, color: Colors.black54),
                                                const SizedBox(height: 8),
                                                Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.8),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    song['title']!,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.8),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    song['artist']!,
                                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (audioService.isLoading.value && audioService.currentIndex.value == index)
                                        const Center(
                                          child: CircularProgressIndicator(strokeWidth: 8),
                                        ),
                                    ],
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: PlayerControls(),
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
