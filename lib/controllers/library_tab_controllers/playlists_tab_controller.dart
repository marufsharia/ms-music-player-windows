import 'package:get/get.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';

class PlaylistsTabController extends GetxController {
  final PlaylistController playlistController = Get.find<PlaylistController>();

  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> playlists = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    isLoading.value = true;
    playlists.value = await playlistController.getPlaylists();
    isLoading.value = false;
  }
}