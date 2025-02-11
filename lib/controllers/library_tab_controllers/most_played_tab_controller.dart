import 'package:get/get.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';

class MostPlayedTabController extends GetxController {
  final PlaylistController playlistController = Get.find<PlaylistController>();

  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> mostPlayedSongs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMostPlayedSongs();
  }

  Future<void> loadMostPlayedSongs() async {
    isLoading.value = true;
    //mostPlayedSongs.value = playlistController.recentSongs; // Assuming recentSongs is used for most played
    isLoading.value = false;
  }
}