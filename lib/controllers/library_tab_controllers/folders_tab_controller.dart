import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/services/metadata_service.dart';
import 'package:path/path.dart' as p;

class FoldersTabController extends GetxController {
  final LibraryController libraryController = Get.find<LibraryController>();
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final AudioService audioService = Get.find<AudioService>();
  final MetadataService metadataService = Get.find<MetadataService>();

  RxBool isLoading = false.obs;
  RxList<String> mediaFiles = <String>[].obs;
  RxMap<String, List<String>> folderMap = <String, List<String>>{}.obs;
  RxList<String> folders = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFolderData();
  }

  Future<void> loadFolderData() async {
    isLoading.value = true;
    mediaFiles.value = libraryController.mediaFiles.toList();
    _groupFilesByFolder();
    isLoading.value = false;
  }

  void _groupFilesByFolder() {
    folderMap.clear();
    for (final filePath in mediaFiles.value) {
      final folderPath = p.dirname(filePath);
      folderMap.putIfAbsent(folderPath, () => []);
      folderMap[folderPath]!.add(filePath);
    }
    folders.value = folderMap.keys.toList();
  }
}