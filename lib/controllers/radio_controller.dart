// lib/controllers/radio_controller.dart
import 'dart:io';

import 'package:get/get.dart';
import 'package:ms_music_player/models/radio_station_model.dart';
import 'package:ms_music_player/services/audio_service.dart';


class RadioController extends GetxController {
  final AudioService audioService =
      Get.find<AudioService>(); // Get instance of AudioService
  RxList<RadioStationModel> radioStations = <RadioStationModel>[].obs;
  Rx<RadioStationModel?> currentStation = Rx<RadioStationModel?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isRecording = false.obs; // Recording state


  @override
  void onInit() {
    super.onInit();
    loadRadioStations();
  }

  // **Important:** Replace dummy data with real data loading logic
  Future<void> loadRadioStations() async {
    isLoading.value = true;
    errorMessage.value = '';
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    try {
      radioStations.value = _generateDummyStations(); // Use dummy data for now
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load radio stations.';
      Get.log('Error loading radio stations: $e');
    }
  }

  // **Dummy Radio Station Data - Replace with your actual data source**
  List<RadioStationModel> _generateDummyStations() {
    return [
      RadioStationModel(
        name: 'Radio Paradise',
        streamUrl: 'http://stream.radioparadise.com/mp3-320',
        imageUrl: 'https://www.radioparadise.com/graphics/rp_logo_90.png',
        genre: 'Eclectic Rock, World, Electronica',
        description:
            'Eclectic mix of rock, electronica, world, classical, jazz, and more.',
      ),
      RadioStationModel(
        name: 'BBC Radio 1',
        streamUrl: 'http://stream.live.vc.bbcmedia.co.uk/bbc_radio_one',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/en/thumb/5/5a/BBC_Radio_1_logo.svg/240px-BBC_Radio_1_logo.svg.png',
        genre: 'Pop, Chart, Dance',
        description: 'UK\'s leading contemporary music radio station.',
      ),
      RadioStationModel(
        name: 'Jazz24',
        streamUrl: 'https://jazz24.org/Jazz24.mp3',
        imageUrl:
            'https://jazz24.org/wp-content/uploads/2019/07/cropped-JAZZ24_Logo_BW_footer_300x300.png',
        genre: 'Jazz',
        description: 'The best in jazz music, 24 hours a day.',
      ),
    ];
  }

  Future<void> playRadio(RadioStationModel station) async {
    currentStation.value = station;
    errorMessage.value = '';
    try {
      await audioService.player
          .stop(); // Stop any current audio in AudioService
      await audioService.player
          .setUrl(station.streamUrl); // Set radio stream URL
      audioService.play(); // Start playing using AudioService's play method
    } catch (e) {
      errorMessage.value = 'Error loading stream: ${e.toString()}';
      Get.log('Error playing radio: $e');
    }
  }

  void stopRadio() {
    audioService.stop();
    currentStation.value = null;
  }

  void pauseRadio() {
    audioService.pause();
  }

  void resumeRadio() {
    audioService.play();
  }

  @override
  void onClose() {
    stopRadio();
    super.onClose();
  }
}
