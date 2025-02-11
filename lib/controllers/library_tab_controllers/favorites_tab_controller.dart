import 'package:get/get.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';

class FavoritesTabController extends GetxController {
  final PlaylistController playlistController = Get.find<PlaylistController>();

  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> favoriteSongs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoriteSongs();
  }

  Future<void> loadFavoriteSongs() async {
    isLoading.value = true;
   // favoriteSongs.value = await playlistController.getFavoriteSongs();
    isLoading.value = false;
  }
}