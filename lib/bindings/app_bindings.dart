import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/services/library_service.dart';
import '../controllers/playlist_controller.dart';
import '../services/audio_service.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaylistController>(() => PlaylistController(), fenix: true);
    Get.lazyPut<AudioService>(() => AudioService(), fenix: true);
    Get.lazyPut<LibraryController>(() => LibraryController(), fenix: true);
    Get.lazyPut<LibraryManager>(() => LibraryManager(), fenix: true);

  }
}