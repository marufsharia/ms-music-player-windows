// lib/ui/screens/equalizer_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({Key? key}) : super(key: key);

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  // Define frequency bands (you can customize these)
  final List<String> frequencyBandsLabels = [
    '60Hz',
    '150Hz',
    '400Hz',
    '1kHz',
    '2.5kHz',
    '6kHz',
    '16kHz',
  ];
  List<double> bandGains = [0, 0, 0, 0, 0, 0, 0]; // Initial gains in dB

  // Preset names
  final List<String> presetNames = [
    'Custom',
    'Flat',
    'Rock',
    'Pop',
    'Classical',
    'Jazz'
  ];
  String currentPreset = 'Custom';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(
              title: 'Equalizer',
              isBackButtonVisible: true,
              onBackButtonPressed: () => Get.back(),
            ),
            _buildPresetDropdown(),
            const SizedBox(height: 20),
            _buildEqualizerBands(),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetDropdown() {
    return Row(
      children: [
        const Text('Presets: '),
        DropdownButton<String>(
          value: currentPreset,
          icon: Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: (String? newValue) {
            setState(() {
              currentPreset = newValue!;
              _applyPreset(newValue);
            });
          },
          items: presetNames.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEqualizerBands() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(frequencyBandsLabels.length, (index) {
          return _buildBandSlider(index);
        }),
      ),
    );
  }

  Widget _buildBandSlider(int index) {
    return Column(
      children: [
        Text(frequencyBandsLabels[index]),
        RotatedBox(
          quarterTurns: -1, // Make slider vertical
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              thumbColor: Theme.of(context).colorScheme.secondary,
              overlayColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.4),
            ),
            child: Slider(
              value: bandGains[index],
              min: -12.0,
              // dB range (you can adjust)
              max: 12.0,
              divisions: 24,
              label: bandGains[index].toStringAsFixed(0) + 'dB',
              onChanged: (double value) {
                setState(() {
                  bandGains[index] = value;
                  currentPreset =
                      'Custom'; // Reset to custom if user adjusts sliders
                });
              },
            ),
          ),
        ),
        Text('${bandGains[index].toStringAsFixed(0)} dB'),
      ],
    );
  }

  void _applyPreset(String presetName) {
    setState(() {
      switch (presetName) {
        case 'Flat':
          bandGains = List.filled(frequencyBandsLabels.length, 0.0);
          break;
        case 'Rock':
          bandGains = [6, 4, 2, 0, 2, 4, 6]; // Example Rock preset
          break;
        case 'Pop':
          bandGains = [2, 3, 4, 5, 4, 3, 2]; // Example Pop preset
          break;
        case 'Classical':
          bandGains = [-2, 0, 2, 4, 2, 0, -2]; // Example Classical preset
          break;
        case 'Jazz':
          bandGains = [0, 2, 4, 2, 0, -2, -4]; // Example Jazz preset
          break;
        case 'Custom':
        default:
          // 'Custom' preset is handled by manual slider adjustments. No action needed here.
          break;
      }
    });
  }
}
