import 'package:get/get.dart';
import 'package:ms_music_player/screens/about_page.dart';
import 'package:ms_music_player/screens/equalizer_screen.dart';
import 'package:ms_music_player/screens/home_page.dart';
import 'package:ms_music_player/screens/library_page.dart';
import 'package:ms_music_player/screens/playlist_page.dart';
import 'package:ms_music_player/screens/radio_screen.dart';
import 'package:ms_music_player/screens/recorder_screen.dart';
import 'package:ms_music_player/screens/settings_page.dart';

class RouteManager {
  static const initial = Routes.homePage;

  static List<GetPage> getPages() {
    return [
      GetPage(name: Routes.homePage, page: () => HomePage()),
      GetPage(name: Routes.playListPage, page: () => PlaylistPage()),
      GetPage(name: Routes.settingsPage, page: () => SettingsPage()),
      GetPage(name: Routes.libraryPage, page: () => LibraryPage()),
      GetPage(name: Routes.equalizerPage, page: () => EqualizerScreen()),
      GetPage(name: Routes.aboutPage, page: () => AboutScreen()),
      GetPage(name: Routes.radioPage, page: () => RadioScreen()),
      GetPage(name: Routes.recorderPage, page: () => RecorderScreen()),
    ];
  }
}

class Routes {
  static const homePage = '/';
  static const playListPage = '/PlaylistPage';
  static const settingsPage = '/SettingsPage';
  static const libraryPage = '/LibraryPage';
  static const equalizerPage = '/EqualizerPage';
  static const radioPage = '/RadioPage';
  static const aboutPage = '/AboutPage';
  static const recorderPage = '/RecorderPage';
}
