import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class ArtistsTabController extends GetxController {
  final LibraryController libraryController = Get.find<LibraryController>();
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final AudioService audioService = Get.find<AudioService>();
  final MetadataService metadataService = Get.find<MetadataService>();

  RxBool isLoading = false.obs;
  RxList<String> mediaFiles = <String>[].obs;
  RxMap<String, List<String>> artistMap = <String, List<String>>{}.obs;
  RxList<String> artists = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadArtistData();
  }

  Future<void> loadArtistData() async {
    isLoading.value = true;
    mediaFiles.value = libraryController.mediaFiles.toList();
    _groupFilesByArtist();
    isLoading.value = false;
  }

  Future<void> _groupFilesByArtist() async {
    artistMap.clear();
    for (final filePath in mediaFiles.value) {
      final metadata = await metadataService.extractMetadata(filePath);
      final artistName = metadata['artist'] ?? 'Unknown Artist';
      artistMap.putIfAbsent(artistName, () => []);
      artistMap[artistName]!.add(filePath);
    }
    artists.value = artistMap.keys.toList();
  }
}