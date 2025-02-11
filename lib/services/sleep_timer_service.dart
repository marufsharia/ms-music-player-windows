// SleepTimer Service
import 'dart:async';

import 'package:get/get.dart';
import 'package:ms_music_player/services/audio_service.dart';

class SleepTimerService extends GetxService {
  final Rx<Duration> remainingTime = Duration.zero.obs;
  final AudioService audioService = Get.find();
  Timer? _timer;

  void startTimer(Duration duration) {
    remainingTime.value = duration;
    _timer = Timer.periodic(1.seconds, (timer) {
      Get.snackbar('title', remainingTime.value.inSeconds.toString());
      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value -= 1.seconds;
      } else {
        audioService.pause();
        timer.cancel();
      }
    });
  }
}