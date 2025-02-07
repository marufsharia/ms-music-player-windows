import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';

class AudioService extends GetxService {
  final AudioPlayer _player = AudioPlayer();
  final PlaylistController playlistController = Get.find();

  // Reactive Variables
  RxBool isPlaying = false.obs;
  RxBool isShuffleEnabled = false.obs;
  RxBool isRepeatEnabled = false.obs;
  RxString currentSongTitle = "".obs;
  RxString currentArtistName = "".obs;
  RxString currentPosition = "0:00".obs;
  RxString currentAlbumArt = "".obs;
  RxString totalDuration = "0:00".obs;
  RxDouble position = 0.0.obs;
  RxDouble duration = 0.0.obs;
  RxDouble volume = 0.5.obs;
  RxInt currentIndex = (-1).obs;
  RxBool isMuted = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupAudioListeners();
    _player.setVolume(volume.value);
  }

  void _setupAudioListeners() {
    _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _handlePlaybackCompletion();
      }
    });

    _player.positionStream.listen((pos) {
      position.value = pos.inSeconds.toDouble();
      currentPosition.value = _formatDuration(pos);
    });

    _player.durationStream.listen((dur) {
      duration.value = dur?.inSeconds.toDouble() ?? 0.0;
      totalDuration.value = dur != null ? _formatDuration(dur) : "0:00";
    });
  }

  Future<void> loadAudioSource(int index) async {
    if (index.isNegative || index >= playlistController.songs.length) return;
    currentIndex.value = index;
    final song = playlistController.songs[index];
    try {
      currentSongTitle.value = song['title'] ?? 'Unknown Title';
      currentArtistName.value = song['artist'] ?? 'Unknown Artist';
      currentAlbumArt.value = song['album_art'] ?? '';

      await _player.setAudioSource(
        AudioSource.uri(Uri.file(song['file_path']!)),
        initialIndex: index,
        preload: true,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to load audio: ${e.toString()}");
    }
  }

  /// Play audio
  Future<void> play() async {
    try {
      await _player.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  /// Pause audio
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  /// Stop audio
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  /// Toggle shuffle mode
  void toggleShuffle() {
    isShuffleEnabled.value = !isShuffleEnabled.value;
    _player.setShuffleModeEnabled(isShuffleEnabled.value);
  }

  /// Toggle repeat mode
  void toggleRepeat() {
    isRepeatEnabled.value = !isRepeatEnabled.value;
    _player.setLoopMode(
      isRepeatEnabled.value ? LoopMode.all : LoopMode.off,
    );
  }

  /// Seek to a specific position in the current track
  void seek(double seconds) {
    _player.seek(Duration(seconds: seconds.toInt()));
  }

  /// Adjust the volume
  void setVolume(double value) {
    volume.value = value;
    _player.setVolume(value);
    if (_player.volume > 0) {
      isMuted.value = false;
    } else {
      isMuted.value = true;
    }
  }

  //mute audio
  Future<void> mute() async {
    try {
      if (_player.volume > 0) {
        volume.value = _player.volume;
        await _player.setVolume(0);
        isMuted.value = true;
      } else {
        await _player.setVolume(volume.value);
        isMuted.value = false;
      }
    } catch (e) {
      print("Error muting/unmuting audio: $e");
    }
  }

  /// Format a [Duration] into a string (MM:SS)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> playNext() async {
    if (playlistController.songs.isEmpty) return;

    final nextIndex = currentIndex.value + 1;
    if (nextIndex < playlistController.songs.length) {
      await loadAudioSource(nextIndex);
      await play();
    }
  }

  Future<void> playPrevious() async {
    if (currentIndex.value > 0) {
      await loadAudioSource(currentIndex.value - 1);
      await play();
    }
  }

  void _handlePlaybackCompletion() {
    if (isRepeatEnabled.value) {
      _player.seek(Duration.zero);
      _player.play();
    } else {
      playNext();
      _player.play();
    }
  }

  // get Audio player instance
  AudioPlayer get player => _player;

  /// Dispose the audio player when the service is no longer needed
  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
