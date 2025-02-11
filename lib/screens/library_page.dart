import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/controllers/library_controller.dart'; // Import LibraryController
import 'package:ms_music_player/controllers/playlist_controller.dart'; // Import PlaylistController
import 'package:ms_music_player/services/audio_service.dart'; // Import AudioService
import 'package:ms_music_player/services/library_service.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:ms_music_player/widgets/sidebar.dart';

import '../widgets/horizontal_loading_indicator.dart';
import 'library_tabs/albums_tab_view.dart';
import 'library_tabs/all_songs_tab_view.dart';
import 'library_tabs/artists_tab_view.dart';
import 'library_tabs/favorites_tab_view.dart';
import 'library_tabs/folders_tab_view.dart';
import 'library_tabs/genres_tab_view.dart';
import 'library_tabs/most_played_tab_view.dart';
import 'library_tabs/playlists_tab_view.dart';
import 'library_tabs/recommended_tab_view.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final LibraryController _libraryController =
      Get.find(); // Get LibraryController
  final AudioService audioService = Get.find(); // Get AudioService
  final PlaylistController playlistController =
      Get.find(); // Get PlaylistController

  RxBool _isAddingCustomFolderLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _libraryController.refreshLibrary(); // Refresh library data on page load
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 800;
        return Column(
          children: [
            CustomAppBar(
              title: 'Library Management',
              isBackButtonVisible: true,
              onBackButtonPressed: () => Get.back(),
            ),
            Expanded(
              child: Row(
                children: [
                  // Sidebar
                  if (isWideScreen) Sidebar(audioService: audioService),

                  // Main Content Area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildLibraryActions(context),
                          const SizedBox(height: 16),
                          TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabs: const [
                              Tab(text: 'All Songs'),
                              Tab(text: 'Folders'),
                              Tab(text: 'Artists'),
                              Tab(text: 'Albums'),
                              Tab(text: 'Genres'),
                              Tab(text: 'Playlists'),
                              Tab(text: 'Favorites'),
                              Tab(text: 'Most Played'),
                              Tab(text: 'Recommended'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                AllSongsTabView(key: UniqueKey()),
                                FoldersTabView(key: UniqueKey()),
                                ArtistsTabView(key: UniqueKey()),
                                AlbumsTabView(key: UniqueKey()),
                                GenresTabView(key: UniqueKey()),
                                PlaylistsTabView(key: UniqueKey()),
                                FavoritesTabView(key: UniqueKey()),
                                MostPlayedTabView(key: UniqueKey()),
                                RecommendedTabView(key: UniqueKey()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLibraryActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage your library",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Scan default folders or add custom folders to manage your library.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  // await LibraryManager.instance.scanDefaultFolders();
                  await _libraryController.refreshLibrary();
                },
                icon: const Icon(Icons.folder),
                label: const Text('Scan Default Folders'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  _setAddingCustomFolderLoading(true); // Start loading
                  await LibraryManager.instance.addCustomFolder(context);
                  _libraryController.refreshLibrary();
                  _setAddingCustomFolderLoading(false); // Start loading
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Custom Folder'),
              ),
            ],
          ),
          Center(
            child: Obx(() => _isAddingCustomFolderLoading.value
                ? const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: HorizontalLoadingIndicator(
                      // Use HorizontalLoadingIndicator here
                      text: "Scanning and adding to database...", // Add your text
                    ),
                  )
                : const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }

  void _setAddingCustomFolderLoading(bool isLoading) {
    _isAddingCustomFolderLoading.value = isLoading;
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          Get.snackbar(
            'Page 0 tapped.',
            'Page0tapped.',
          );
          break;
        case 1:
          Get.snackbar(
            'Page 1 tapped.',
            'Page 1 tapped.',
          );
          break;
      }
    }
  }
}
