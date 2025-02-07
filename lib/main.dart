import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/bindings/app_bindings.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/route/route_manager.dart';
import 'package:ms_music_player/services/metadata_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugin is initialized
  final metadataService = MetadataService();
  metadataService.setupFFmpeg(); // Call the setup method
  sqfliteFfiInit(); // Initialize FFI bindings for sqflite plugin
  databaseFactory = databaseFactoryFfi; // Use FFI database factory for sqflite
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
