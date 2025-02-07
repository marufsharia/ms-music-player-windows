import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/services/library_service.dart';
import 'package:ms_music_player/controllers/library_controller.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:ms_music_player/widgets/sidebar.dart';

class LibraryPage extends StatelessWidget {
  final LibraryManager _libraryManager = Get.put(LibraryManager());
  final LibraryController _libraryController = Get.put(LibraryController());
  final AudioService audioService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) {
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
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildLibraryActions(context),
                                  const SizedBox(height: 16),
                                  Expanded(child: _buildLibraryContents()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
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
                  await _libraryManager.scanDefaultFolders();
                  _libraryController.refreshLibrary();
                },
                icon: const Icon(Icons.folder),
                label: const Text('Scan Default Folders'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await _libraryManager.addCustomFolder(context);
                  _libraryController.refreshLibrary();
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Custom Folder'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryContents() {
    return Obx(() {
      if (_libraryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Obx(() {
        final mediaFiles = _libraryController.mediaFiles;

        if (mediaFiles.isEmpty) {
          return Center(
            child: Text(
              'No media files found.',
              style: Theme.of(Get.context!).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.separated(
          itemCount: mediaFiles.length,
          separatorBuilder: (context, index) => Divider(
            color: Theme.of(context).dividerColor,
            height: 1,
          ),
          itemBuilder: (context, index) {
            final filePath = mediaFiles[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.music_note,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                filePath.split('/').last,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                filePath,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                // Handle file selection
              },
            );
          },
        );
      });
    });
  }
}
