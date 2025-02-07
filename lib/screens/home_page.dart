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
            CustomAppBar( // CustomAppBar widget
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
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome to MS Music",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Your personal music companion with a modern touch.",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.play_arrow),
                                  label: Text("Start Listening"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
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
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
