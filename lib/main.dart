import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/bindings/app_bindings.dart';
import 'package:ms_music_player/controllers/home_controller.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:ms_music_player/controllers/radio_controller.dart';
import 'package:ms_music_player/route/route_manager.dart';
import 'package:ms_music_player/services/audio_recorder_service.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/services/database_service.dart';
import 'package:ms_music_player/services/metadata_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugin is initialized
  final metadataService = MetadataService();
  metadataService.setupFFmpeg(); // Call the setup method
  sqfliteFfiInit(); // Initialize FFI bindings for sqflite plugin
  databaseFactory = databaseFactoryFfi; // Use FFI database factory for sqflite

// Initialize core services first
  await Get.putAsync(() => DatabaseService().initialize());
  Get.put(MetadataService());
  // Initialize controllers
  Get.put(PlaylistController());
  Get.put(LibraryController());
  Get.put(HomeController());
  Get.put(AudioRecorderService());
  // Initialize audio service last
  Get.put(AudioService());
  Get.put(RadioController());

  runApp(MyApp());
  doWhenWindowReady(() {
    appWindow.size = const Size(1000, 800);
    appWindow.minSize = const Size(600, 400);
    appWindow.alignment = Alignment.center;
    appWindow.title = "MS Music Player";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData.dark(),
      initialBinding: AppBindings(),
      defaultTransition: Transition.fadeIn,
      initialRoute: RouteManager.initial,
      getPages: RouteManager.getPages(),
      darkTheme: ThemeData.dark(),
    );
  }
}
