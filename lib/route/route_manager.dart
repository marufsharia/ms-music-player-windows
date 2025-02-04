import 'package:get/get.dart';
import 'package:ms_music_player/screens/MusicPlayerHome.dart';
import 'package:ms_music_player/screens/playlist_page.dart';


class RouteManager {
  static const initial = Routes.musicPlayerHome;

  static List<GetPage> getPages() {
    return [
      GetPage(name: Routes.musicPlayerHome, page: () => MusicPlayerHome()),
      GetPage(name: Routes.playListPage, page: () => PlaylistPage()),
    ];
  }
}

class Routes {
  static const musicPlayerHome = '/';
  static const playListPage = '/PlaylistPage';
}
