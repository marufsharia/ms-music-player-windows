import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../widgets/player_controls.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioService _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Music Player")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 100, color: Colors.blueAccent),
          SizedBox(height: 20),
          PlayerControls(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (){},
            child: const Text("Open Playlist"),
          ),
        ],
      ),
    );
  }
}
