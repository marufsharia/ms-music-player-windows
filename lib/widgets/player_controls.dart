import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/audio_service.dart';

class PlayerControls extends StatelessWidget {
  final AudioService audioService = Get.find();

  PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = Theme.of(context);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSongInfo(theme),
              const SizedBox(height: 16),
              _buildPlaybackControls(theme),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _buildProgressControls(theme)),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 8, top: 0, bottom: 16),
                    child: _buildVolumeControls(theme),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSongInfo(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.music_note,
              color: theme.colorScheme.onPrimaryContainer),
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
          icon: Icon(Icons.shuffle,
              color: audioService.isShuffleEnabled.value
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface),
          tooltip: 'Shuffle',
          onPressed: audioService.toggleShuffle,
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          tooltip: 'Previous track',
          onPressed: audioService.playPrevious,
        ),
        _buildPlayPauseButton(theme),
        IconButton(
          icon: const Icon(Icons.skip_next),
          tooltip: 'Next track',
          onPressed: audioService.playNext,
        ),
        IconButton(
          icon: Icon(Icons.repeat,
              color: audioService.isRepeatEnabled.value
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface),
          tooltip: 'Repeat',
          onPressed: audioService.toggleRepeat,
        ),
      ],
    );
  }

  Widget _buildPlayPauseButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          audioService.isPlaying.value ? Icons.pause : Icons.play_arrow,
          color: theme.colorScheme.onPrimary,
          size: 32,
        ),
        iconSize: 40,
        onPressed: () =>
        audioService.isPlaying.value
            ? audioService.pause()
            : audioService.play(),
      ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(audioService.currentPosition.value,
                  style: theme.textTheme.labelSmall),
              Text(audioService.totalDuration.value,
                  style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeControls(ThemeData theme) {
    return Obx(() {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              audioService.isMuted.value ? Icons.volume_off : Icons.volume_up,
              size: 20,
            ),
            color: theme.colorScheme.onSurface,
            onPressed: () {
              audioService.mute();
            },
          ),
          Slider(
            value: audioService.volume.value,
            min: 0,
            max: 1,
            divisions: 10,
            label: '${(audioService.volume.value * 100).round()}%',
            onChanged: audioService.setVolume,
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.surfaceVariant,
          ),

        ],
      );
    });
  }
}
