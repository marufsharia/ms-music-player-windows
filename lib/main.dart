import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/bindings/app_bindings.dart';
import 'package:ms_music_player/route/route_manager.dart';
import 'package:ms_music_player/screens/MusicPlayerHome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugin is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData.dark(),
      initialBinding: AppBindings(), // Add this line
      initialRoute: RouteManager.initial,
      getPages: RouteManager.getPages(),
    );
  }
}
