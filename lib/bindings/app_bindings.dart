import 'package:get/get.dart';
import '../controllers/playlist_controller.dart';
import '../services/audio_service.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    // Initialize PlaylistController first
    Get.lazyPut<PlaylistController>(() => PlaylistController(), fenix: true);
    // Initialize AudioService that depends on PlaylistController
    Get.lazyPut<AudioService>(() => AudioService(), fenix: true);
  }
}