import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:ms_music_player/widgets/player_controls.dart';
import 'package:ms_music_player/widgets/sidebar.dart';

class MusicPlayerHome extends StatelessWidget {
  final AudioService _audioService = Get.put(AudioService());
  final borderColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WindowBorder(
        color: borderColor,
        width: 1,
        child: Column(
          children: [
            CustomAppBar(
              // CustomAppBar widget
              title: 'MS Music Player',
              isBackButtonVisible: false,
              onBackButtonPressed: () {
                Get.back();
              },
            ),
            Expanded(
              child: Row(
                children: [
                  // Sidebar Navigation
                  Sidebar(audioService: _audioService),
                  // Main Content Area
                  Expanded(
                    child: Column(
                      children: [
                        // Welcome Section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " Welcome to MS Music Player",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Manage your library, play your favorite songs, and enjoy the music!",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await _audioService.loadAudioSource(0);
                                        _audioService.play();
                                      },
                                      icon: const Icon(Icons.play_arrow),
                                      label: const Text('Playing Now'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Recently Played Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Recently Played",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: 8, // Replace with your data count
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "Song Title ${index + 1}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Bottom Player Controls
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: PlayerControls(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
