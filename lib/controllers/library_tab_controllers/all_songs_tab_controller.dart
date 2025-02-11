import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class AllSongsTabController extends GetxController {
  final LibraryController libraryController = Get.find<LibraryController>();
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final AudioService audioService = Get.find<AudioService>();
  final MetadataService metadataService = Get.find<MetadataService>();

  RxBool isLoading = false.obs;
  RxList<String> mediaFiles = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMediaFiles();
  }

  Future<void> loadMediaFiles() async {
    isLoading.value = true;
    mediaFiles.value = libraryController.mediaFiles.toList(); // Use existing mediaFiles from LibraryController
    isLoading.value = false;
  }

// You can add methods here specific to AllSongsTabView if needed, like sorting, filtering, etc.
}