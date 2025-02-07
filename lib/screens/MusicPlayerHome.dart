import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/route/route_manager.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/widgets/player_controls.dart';

class MusicPlayerHome extends StatelessWidget {
  final AudioService _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 200,
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
                ),
                ListTile(
                  leading: Icon(Icons.library_music, color: Colors.white),
                  title: Text("Library", style: TextStyle(color: Colors.white))),
                ListTile(
                    leading: Icon(Icons.playlist_play, color: Colors.white),
                    title: Text("Playlists",
                        style: TextStyle(color: Colors.white)),
                    onTap: () => Get.toNamed(Routes.playListPage,
                        arguments: _audioService)),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title:
                      Text("Settings", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

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
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to MS Music",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                            "Your personal music companion with a modern touch."),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.play_arrow),
                          label: Text("Start Listening"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text("Song Title ${index + 1}"),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Player Controls
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child:  PlayerControls(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
