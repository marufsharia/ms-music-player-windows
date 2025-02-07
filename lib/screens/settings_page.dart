import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/services/audio_service.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:ms_music_player/widgets/sidebar.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  double playbackSpeed = 1.0;
  final AudioService audioService = Get.put(AudioService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;
          return Column(
            children: [
              CustomAppBar(
                title: 'Library Management',
                isBackButtonVisible: true,
                onBackButtonPressed: () => Get.back(),
              ),
              Expanded(
                child: Row(
                  children: [
                    if (isWideScreen) Sidebar(audioService: audioService),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: [
                            ListTile(
                              title: Text("Library Management"),
                              subtitle:
                                  Text("Manage media folders and metadata."),
                              leading: Icon(Icons.library_music),
                              onTap: () {},
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Playback Controls"),
                              subtitle: Text("Customize playback settings."),
                              leading: Icon(Icons.play_circle_fill),
                              onTap: () {},
                            ),
                            Divider(),
                            SwitchListTile(
                              title: Text("Dark Mode"),
                              subtitle:
                                  Text("Toggle between light and dark mode."),
                              value: isDarkMode,
                              onChanged: (value) {
                                if (isDarkMode) {
                                  Get.changeTheme(ThemeData.light());
                                } else {
                                  Get.changeTheme(ThemeData.dark());
                                }
                                setState(() {
                                  isDarkMode = value;
                                });
                              },
                              secondary: Icon(Icons.brightness_6),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Playback Speed"),
                              subtitle: Text(
                                  "Adjust the speed of audio/video playback."),
                              leading: Icon(Icons.speed),
                              trailing: DropdownButton<double>(
                                value: playbackSpeed,
                                items: [0.25, 0.5, 1.0, 1.5, 2.0]
                                    .map((speed) => DropdownMenuItem(
                                          value: speed,
                                          child: Text("${speed}x"),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    playbackSpeed = value!;
                                  });
                                },
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text("Equalizer"),
                              subtitle: Text("Adjust sound settings."),
                              leading: Icon(Icons.equalizer),
                              onTap: () {},
                            ),
                          ],
                        ),
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
}
