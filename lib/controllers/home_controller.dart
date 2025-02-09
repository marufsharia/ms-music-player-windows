//homeController
import 'package:get/get.dart';
import 'package:ms_music_player/services/database_service.dart';

class HomeController extends GetxController {

  RxList<Map<String, dynamic>> favoriteSongs = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> recentSongs = <Map<String, dynamic>>[].obs;

  RxBool isGridView = false.obs;
  RxBool isLoadingFavorites = false.obs;
  RxBool isLoadingRecent = false.obs;
  final DatabaseService _dbService = Get.find();

  @override
  Future<void> onInit() async {
    super.onInit();
   await _loadInitialData();

  }

  Future<void> _loadInitialData() async {
    await loadFavorites();
    await loadRecentPlays();
  }


  void refreshRecentSongs() {
    loadRecentPlays();
  }

  Future<void> loadFavorites() async {
    isLoadingFavorites.value = true;
    try {
      final songs = await _dbService.getFavoriteSongs();
      favoriteSongs.assignAll(songs);
    } finally {
      isLoadingFavorites.value = false;
    }
  }
  Future<void> loadRecentPlays() async {
    recentSongs.value = await _dbService.getRecentPlayedSongs();
  }

  Future<void> toggleFavorite(Map<String, dynamic> song) async {
    final filePath = song['file_path'];
    final isFavorite = await _dbService.isFavorite(filePath);

    if (isFavorite) {
      await _dbService.removeFromFavorites(filePath);
      favoriteSongs.removeWhere((s) => s['file_path'] == filePath);
    } else {
      await _dbService.addToFavorites({
        'file_path': filePath,
        'title': song['title'],
        'artist': song['artist']
      });
      favoriteSongs.add(song);
    }
    favoriteSongs.refresh();
  }

  void removeRecent(int index) async {
    await _dbService.removeRecentPlayed(recentSongs[index]['file_path']);
      recentSongs.removeAt(index);
  }




}