import 'package:get/get.dart';
import 'package:ms_music_player/screens/home_page.dart';
import 'package:ms_music_player/screens/library_page.dart';
import 'package:ms_music_player/services/library_service.dart';
import 'package:ms_music_player/screens/playlist_page.dart';
import 'package:ms_music_player/screens/settings_page.dart';


class RouteManager {
  static const initial = Routes.musicPlayerHome;

  static List<GetPage> getPages() {
    return [
      GetPage(name: Routes.musicPlayerHome, page: () => MusicPlayerHome()),
      GetPage(name: Routes.playListPage, page: () => PlaylistPage()),
      GetPage(name: Routes.settingsPage, page: () =>  SettingsPage()),
      GetPage(name: Routes.libraryPage, page: () =>  LibraryPage()),
    ];
  }
}

class Routes {
  static const musicPlayerHome = '/';
  static const playListPage = '/PlaylistPage';
  static const settingsPage = '/SettingsPage';
  static const libraryPage = '/LibraryPage';
}
