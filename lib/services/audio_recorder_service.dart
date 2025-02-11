import 'dart:async';
import 'dart:io';



import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ms_music_player/controllers/playlist_controller.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderService extends GetxService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final RxBool isRecording = false.obs;
  final RxBool isPaused = false.obs;
  final RxString recordingPath = ''.obs;
  final Rx<Duration> recordingDuration = Duration.zero.obs;
  Timer? _timer;
  bool _isRecorderOpen = false;

  @override
  void onInit() async {
    await _initializeRecorder();
    super.onInit();
  }

  Future<void> _initializeRecorder() async {

    try {
      await _recorder.openRecorder();
     // await _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
      _isRecorderOpen = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize recorder: ${e.toString()}');
    }
  }

  Future<void> startRecording() async {
    if (!_isRecorderOpen) {
      await _initializeRecorder();
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'recording_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.aac';
      recordingPath.value = '${directory.path}\\$fileName';

      await _recorder.startRecorder(
        toFile: recordingPath.value,
        codec: Codec.mp3,
        bitRate: 128000,
        sampleRate: 44100,
      );

      isRecording.value = true;
      _startTimer();
    } catch (e) {
      Get.log('Error starting recording: $e');
      Get.snackbar('Error', 'Failed to start recording: ${e.toString()}');
    }
  }

  Future<void> pauseRecording() async {
    if (isRecording.value && !isPaused.value) {
      await _recorder.pauseRecorder();
      isPaused.value = true;
      _timer?.cancel();
    }
  }

  Future<void> resumeRecording() async {
    if (isRecording.value && isPaused.value) {
      await _recorder.resumeRecorder();
      isPaused.value = false;
      _startTimer();
    }
  }

  Future<void> stopRecording() async {
    try {
      if (_isRecorderOpen) {
        await _recorder.stopRecorder();
        _timer?.cancel();
        isRecording.value = false;
        isPaused.value = false;
        recordingDuration.value = Duration.zero;

        // Add recording to playlist
        final playlistController = Get.find<PlaylistController>();
        await playlistController.addRecording(recordingPath.value);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop recording: ${e.toString()}');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingDuration.value += const Duration(seconds: 1);
    });
  }

  String get formattedDuration {
    final hours = recordingDuration.value.inHours.toString().padLeft(2, '0');
    final minutes =
        (recordingDuration.value.inMinutes % 60).toString().padLeft(2, '0');
    final seconds =
        (recordingDuration.value.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // Helper function to open the file location (Windows Explorer)
  void _openFileLocation(String filePath) async {
    if (Platform.isWindows) {
      Process.run('explorer', ['/select,', filePath]); // For Windows
    } else {
      Get.snackbar('File Saved',
          'Recording saved to: $filePath'); // For other platforms, just show path
      Get.log('Recording saved to: $filePath');
    }
  }

  @override
  void onClose() {
    _recorder.closeRecorder();
    _timer?.cancel();
    super.onClose();
  }
}
