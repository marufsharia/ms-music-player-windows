import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/services/audio_recorder_service.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:ms_music_player/widgets/sidebar.dart';

class RecorderScreen extends StatelessWidget {
  final AudioRecorderService recorder = Get.find();
  final AudioService audioService = Get.find();

  @override
  Widget build(BuildContext context){
  final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 800;
            int crossAxisCount = isWideScreen ? 6 : 2;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAppBar(
                  title: 'Playlist',
                  isBackButtonVisible: true,
                  onBackButtonPressed: () => Get.back(),
                ),
                Expanded(
                  child: Row(
                    children: [
                    if(isWideScreen)  Sidebar(audioService: audioService),
                     Expanded(
                       child: Center(
                         child: Column(
                           children: [
                             Obx(() => Text(
                               recorder.formattedDuration,
                               style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                             )),
                             const SizedBox(height: 30),
                             Obx(() {
                               if (recorder.isRecording.value) {
                                 return Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     if (recorder.isPaused.value)
                                       IconButton(
                                         icon: const Icon(Icons.play_arrow, size: 50),
                                         onPressed: recorder.resumeRecording,
                                       )
                                     else
                                       IconButton(
                                         icon: const Icon(Icons.pause, size: 50),
                                         onPressed: recorder.pauseRecording,
                                       ),
                                     IconButton(
                                       icon: const Icon(Icons.stop, size: 50, color: Colors.red),
                                       onPressed: recorder.stopRecording,
                                     ),
                                   ],
                                 );
                               } else {
                                 return IconButton(
                                   icon: const Icon(Icons.mic, size: 50),
                                   onPressed: recorder.startRecording,
                                 );
                               }
                             }),
                             Obx(() => Text(
                               recorder.recordingPath.value,
                               style: const TextStyle(fontSize: 12),
                               textAlign: TextAlign.center,
                             )),
                           ],
                         ),
                       ),
                     )
                    ],
                  ),
                ),
              ],
            );
        }
      ),
    );
  }
}