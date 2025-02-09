import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/home_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:ms_music_player/widgets/player_controls.dart';
import 'package:ms_music_player/widgets/sidebar.dart';

class HomePage extends StatelessWidget {
  final AudioService _audioService = Get.find();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 800;
        int crossAxisCount = isWideScreen ? 6 : 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: 'Music Player',
              isBackButtonVisible: false,
              onBackButtonPressed: () => Get.back(),
            ),
            Expanded(
              child: Row(
                children: [
                  if (isWideScreen) Sidebar(audioService: _audioService),
                  Expanded(
                    child: Obx(() => Column(
                      children: [
                        _buildViewToggle(),
                        _buildSectionHeader("Favorites"),
                        _buildSongSection(_homeController.favoriteSongs, true, crossAxisCount),
                        _buildSectionHeader("Recently Played"),
                        _buildSongSection(_homeController.recentSongs, false, crossAxisCount),
                        PlayerControls(),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildViewToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(_homeController.isGridView() ? Icons.list : Icons.grid_view),
          onPressed: (){
            _homeController.isGridView.value= !_homeController.isGridView.value;
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSongSection(RxList<Map<String, dynamic>> songs, bool isFavorite, int crossAxisCount) {
    return Expanded(
      child: _homeController.isGridView.value
          ? _buildGridView(_homeController.favoriteSongs, true, crossAxisCount)
          : _buildListView(_homeController.favoriteSongs, true),
    );
  }

  Widget _buildListView(RxList<Map<String, dynamic>> songs, bool isFavorite) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return Dismissible(
          key: Key(song['file_path']),
          direction: isFavorite ? DismissDirection.none : DismissDirection.endToStart,
          onDismissed: (direction) => _homeController.removeRecent(index),
          background: Container(
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            leading: Icon(
              isFavorite ? Icons.favorite : Icons.history,
              color: isFavorite ? Colors.red : Colors.blue,
            ),
            title: Text(song['title']),
            subtitle: Text(song['artist']),
            onTap: () => _handleSongTap(song),
            trailing: isFavorite
                ? IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.grey),
              onPressed: () => _homeController.toggleFavorite(song),
            )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildGridView(RxList<Map<String, dynamic>> songs, bool isFavorite, int crossAxisCount) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 3 / 2,
      ),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        Get.log('Building grid item: $index');
        final song = songs[index];
        return GestureDetector(
          onTap: () => _handleSongTap(song),
          child: Card(
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isFavorite ? Icons.favorite : Icons.history,
                  color: isFavorite ? Colors.red : Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  song['title'],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song['artist'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSongTap(Map<String, dynamic> song) {
    _audioService.playSong(song);
  }
}