import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ms_music_player/controllers/radio_controller.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:ms_music_player/widgets/sidebar.dart';

class RadioScreen extends StatelessWidget {
  final RadioController radioController = Get.put(RadioController());
  final AudioService audioService = Get.find<AudioService>();

  RadioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;
          return Row(
            children: [
              if (isWideScreen) Sidebar(audioService: audioService),
              Expanded(
                child: Column(
                  children: [
                    CustomAppBar(
                      title: 'Radio',
                      isBackButtonVisible: true,
                      onBackButtonPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Obx(
                            () {
                          if (radioController.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (radioController.errorMessage.value.isNotEmpty) {
                            if (radioController.errorMessage.value.isNotEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      radioController.errorMessage.value,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => radioController.loadRadioStations(),
                                      child: const Text('Refresh'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                          return Column(
                            children: [
                              Expanded(child: _buildRadioStationList()),
                              _buildRadioPlayerControls(context),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRadioStationList() {
    return Obx(() => ListView.builder(
      itemCount: radioController.radioStations.length,
      itemBuilder: (context, index) {
        final station = radioController.radioStations[index];
        return ListTile(
          leading: station.imageUrl != null
              ? Image.network(station.imageUrl!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.radio))
              : const Icon(Icons.radio),
          title: Text(station.name),
          subtitle: station.genre != null ? Text(station.genre!) : null,
          onTap: () => radioController.playRadio(station),
        );
      },
    ));
  }

  Widget _buildRadioPlayerControls(BuildContext context) {
    return Obx(() {
      final currentStation = radioController.currentStation.value;
      final processingState = audioService.player.processingState;
      final isPlaying = audioService.isPlaying.value;

      if (currentStation == null &&
          processingState != ProcessingState.buffering &&
          processingState != ProcessingState.loading) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentStation != null)
              Text(
                currentStation.name,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            if (processingState == ProcessingState.buffering ||
                processingState == ProcessingState.loading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 40,
                  onPressed: () {
                    isPlaying ? radioController.pauseRadio() : radioController.resumeRadio();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  iconSize: 40,
                  onPressed: radioController.stopRadio,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
