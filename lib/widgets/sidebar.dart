import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/route/route_manager.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'dart:io';

class Sidebar extends StatelessWidget {
  final AudioService audioService;

  const Sidebar({super.key, required this.audioService});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.dividerColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(4, 0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildMiniPlayerHeader(theme),
          const SizedBox(height: 20),
          _buildNavItem(
            context,
            Icons.home_outlined,
            "Home",
            Routes.homePage,
            () => Get.toNamed(Routes.homePage),
          ),
          _buildNavItem(
            context,
            Icons.library_music_outlined,
            "Library",
            Routes.libraryPage,
            () => Get.toNamed(Routes.libraryPage, arguments: audioService),
          ),
          _buildNavItem(
            context,
            Icons.playlist_play_outlined,
            "Playlists",
            Routes.playListPage,
            () => Get.toNamed(Routes.playListPage, arguments: audioService),
          ),
          _buildNavItem(
            context,
            Icons.playlist_play_outlined,
            "Radio",
            Routes.radioPage,
            () => Get.toNamed(Routes.radioPage, arguments: audioService),
          ),
          _buildNavItem(
            context,
            Icons.mic,
            "Recorder",
            Routes.radioPage,
            () => Get.toNamed(Routes.recorderPage, arguments: audioService),
          ),
          _buildNavItem(
            context,
            Icons.settings_outlined,
            "Settings",
            Routes.settingsPage,
            () => Get.toNamed(Routes.settingsPage),
          ),
          const Spacer(),
          const Divider(),
          _buildNavItem(context, Icons.info_outline, "About", '', () {
            Get.toNamed(Routes.aboutPage);
          }),
          _buildNavItem(context, Icons.exit_to_app, "Exit", '', () => exit(0)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "© 2025 MS Music Player",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPlayerHeader(ThemeData theme) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: audioService.currentAlbumArt.value.isNotEmpty
                    ? DecorationImage(
                        image:
                            FileImage(File(audioService.currentAlbumArt.value)),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              child: audioService.currentAlbumArt.value.isEmpty
                  ? Icon(Icons.music_note, color: theme.colorScheme.primary)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audioService.currentSongTitle.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    audioService.currentArtistName.value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                audioService.isPlaying.value ? Icons.pause : Icons.play_arrow,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              onPressed: () => audioService.isPlaying.value
                  ? audioService.pause()
                  : audioService.play(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    String routeName,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isSelected = Get.currentRoute == routeName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.8),
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        minLeadingWidth: 24,
        horizontalTitleGap: 8,
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: isSelected
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        hoverColor: theme.colorScheme.primary.withOpacity(0.05),
      ),
    );
  }
}
