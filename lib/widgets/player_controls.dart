import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/audio_service.dart';

class PlayerControls extends StatelessWidget {
  final AudioService audioService = Get.find();

  PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSongInfo(theme),
            _buildPlaybackControls(theme),
            _buildProgressControls(theme),
            _buildExtraControls(theme),
          ],
        ),
      );
    });
  }

  Widget _buildSongInfo(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: theme.colorScheme.primaryContainer,
          backgroundImage: audioService.currentAlbumArt.value.isNotEmpty
              ? FileImage(File(audioService.currentAlbumArt.value))
              : null,
          child: audioService.currentAlbumArt.value.isEmpty
              ? Icon(Icons.music_note,
                  color: theme.colorScheme.onPrimaryContainer)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                audioService.currentSongTitle.value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                audioService.currentArtistName.value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(Icons.shuffle),
            style: IconButton.styleFrom(
              backgroundColor: audioService.isShuffleEnabled.value
            ? theme.colorScheme.primary
                : null, // Background color
              shape: const CircleBorder(),
            ),
            color: audioService.isShuffleEnabled.value
                ? Colors.black
                : Colors.white,
            onPressed: audioService.toggleShuffle),
        IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: audioService.playPrevious),
        _buildPlayPauseButton(theme),
        IconButton(
            icon: Icon(Icons.skip_next), onPressed: audioService.playNext),
        IconButton(
            icon: Icon(Icons.repeat),
            style: IconButton.styleFrom(
              backgroundColor: audioService.isRepeatEnabled.value
                  ? theme.colorScheme.primary
                  : null, // Background color
              shape: const CircleBorder(), // Adjust padding to control size
            ),
            color: audioService.isRepeatEnabled.value
                ? Colors.black
                : Colors.white,
            onPressed: audioService.toggleRepeat),
      ],
    );
  }

  Widget _buildPlayPauseButton(ThemeData theme) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: theme.colorScheme.primary,
      child: Icon(audioService.isPlaying.value ? Icons.pause : Icons.play_arrow,
          size: 32),
      onPressed: () => audioService.isPlaying.value
          ? audioService.pause()
          : audioService.play(),
    );
  }

  Widget _buildProgressControls(ThemeData theme) {
    return Column(
      children: [
        Slider(
          value:
              audioService.position.value.clamp(0, audioService.duration.value),
          min: 0,
          max: audioService.duration.value,
          onChangeEnd: audioService.seek,
          activeColor: theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.surfaceVariant,
          onChanged: (double value) {},
        ),
      ],
    );
  }

  Widget _buildExtraControls(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: Icon(Icons.equalizer), onPressed: () {}),
        // EQ Button
        IconButton(icon: Icon(Icons.playlist_play), onPressed: () {}),
        // Playlist Button
        Row(
          children: [
            IconButton(
              icon: Icon(audioService.isMuted.value
                  ? Icons.volume_off
                  : Icons.volume_up),
              onPressed: audioService.mute,
            ),
            Slider(
              value: audioService.volume.value,
              min: 0,
              max: 1,
              onChanged: audioService.setVolume,
              activeColor: theme.colorScheme.primary,
              inactiveColor: theme.colorScheme.surfaceVariant,
            ),
          ],
        ),
      ],
    );
  }
}
