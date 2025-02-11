import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MusicListItem extends StatelessWidget {
  final Map<String, dynamic> song;
  final VoidCallback? onTap;

  const MusicListItem({Key? key, required this.song, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? albumArtPath = song['album_art']; // Get album art path from song data

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // Album art as background image
          image: DecorationImage(
            image: _getAlbumArtImageProvider(albumArtPath), // Function to get ImageProvider
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              // Handle image loading errors if needed
              print('Error loading album art: $exception');
            },
          ),
        ),
        // No child needed now, as Image is background
      ),
      title: Text(song['title'] ?? 'Unknown Title'),
      subtitle: Text(song['artist'] ?? 'Unknown Artist'),
      onTap: onTap,
      onLongPress: () {
        _showContextMenu(context, song);
      },
    );
  }

  // Function to get ImageProvider for album art (FileImage or AssetImage for default)
  ImageProvider _getAlbumArtImageProvider(String? albumArtPath) {
    if (albumArtPath != null && File(albumArtPath).existsSync()) {
      return FileImage(File(albumArtPath)); // Use album art from file
    } else {
      return const AssetImage('assets/images/default_album_art.png'); // Use default album art from assets
    }
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> song) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Metadata'),
              onTap: () {
               /* Navigator.pop(context);
                Get.to(() => MetadataEditorScreen(song: song))?.then((value) {
                  if (value == true) {
                    Get.log('Metadata updated, refresh list if needed');
                  }
                });*/
              },
            ),
          ],
        );
      },
    );
  }
}