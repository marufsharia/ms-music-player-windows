import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/services/metadata_service.dart';

class AlbumsTabController extends GetxController {
  final LibraryController libraryController = Get.find<LibraryController>();
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final AudioService audioService = Get.find<AudioService>();
  final MetadataService metadataService = Get.find<MetadataService>();

  RxBool isLoading = false.obs;
  RxList<String> mediaFiles = <String>[].obs;
  RxMap<String, List<String>> albumMap = <String, List<String>>{}.obs;
  RxList<String> albums = <String>[].obs;


  @override
  void onInit() {
    super.onInit();
    loadAlbumData();
  }

  Future<void> loadAlbumData() async {
    isLoading.value = true;
    mediaFiles.value = libraryController.mediaFiles.toList();
    _groupFilesByAlbum();
    isLoading.value = false;
  }

  Future<void> _groupFilesByAlbum() async {
    albumMap.clear();
    for (final filePath in mediaFiles.value) {
      final metadata = await metadataService.extractMetadata(filePath);
      final albumName = metadata['album'] ?? 'Unknown Album';
      albumMap.putIfAbsent(albumName, () => []);
      albumMap[albumName]!.add(filePath);
    }
    albums.value = albumMap.keys.toList();
  }
}