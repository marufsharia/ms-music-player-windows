import 'package:get/get.dart';
import 'package:ms_music_player/services/library_service.dart';

class LibraryController extends GetxController {
  var isLoading = false.obs;
  final mediaFiles = <String>[].obs;

  void refreshLibrary() async {
    isLoading.value = true;
    mediaFiles.value = await LibraryManager.instance.getAllMediaFiles();
    isLoading.value = false;
  }
  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }
}
