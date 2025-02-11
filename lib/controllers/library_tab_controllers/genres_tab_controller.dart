import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class GenresTabController extends GetxController {
  final LibraryController libraryController = Get.find<LibraryController>();
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final AudioService audioService = Get.find<AudioService>();
  final MetadataService metadataService = Get.find<MetadataService>();

  RxBool isLoading = false.obs;
  RxList<String> mediaFiles = <String>[].obs;
  RxMap<String, List<String>> genreMap = <String, List<String>>{}.obs;
  RxList<String> genres = <String>[].obs;


  @override
  void onInit() {
    super.onInit();
    loadGenreData();
  }

  Future<void> loadGenreData() async {
    isLoading.value = true;
    mediaFiles.value = libraryController.mediaFiles.toList();
    _groupFilesByGenre();
    isLoading.value = false;
  }

  Future<void> _groupFilesByGenre() async {
    genreMap.clear();
    for (final filePath in mediaFiles.value) {
      // Genre metadata is often unreliable, using placeholder logic for now
      genreMap.putIfAbsent('Unknown Genre', () => []); // Placeholder - replace with actual genre logic
      genreMap['Unknown Genre']!.add(filePath);
    }
    genres.value = genreMap.keys.toList();
  }
}