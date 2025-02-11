import 'package:get/get.dart';
import 'package:ms_music_player/services/library_service.dart';

class LibraryController extends GetxController {
  var isLoading = false.obs;
  final mediaFiles = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshLibrary();
    super.onReady();
  }

  Future<void> refreshLibrary() async {
    isLoading.value = true;
   // Get.log("LibraryController: refreshLibrary() - Starting data refresh..."); // Added log
    final updatedMediaFiles = await LibraryManager.instance.getAllMediaFiles();
    Get.log("LibraryController: refreshLibrary() - Data refresh completed. File count: ${updatedMediaFiles.length}"); // Added log
    mediaFiles.value = updatedMediaFiles; // Update RxList
    //Get.log("LibraryController: refreshLibrary() - Data refresh complete. File count: ${mediaFiles.toString()}"); // Added log
    isLoading.value = false;
  }


  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }
}
