import 'dart:io';
import 'dart:ui';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class MetadataService {
  Future<Map<String, String>> extractMetadata(String audioFilePath) async {
    try {
      final ffmpegPath = await setupFFmpeg();

      ProcessResult result = await Process.run(ffmpegPath, [
        '-i',
        audioFilePath,
      ]);

      String output =
          result.stderr.toString(); // FFmpeg outputs metadata in stderr

      RegExp titleRegex = RegExp(r'title\s*:\s*(.+)');
      RegExp artistRegex = RegExp(r'artist\s*:\s*(.+)');
      RegExp albumRegex = RegExp(r'album\s*:\s*(.+)');
      RegExp durationRegex = RegExp(r'Duration:\s*(\d+:\d+:\d+\.\d+)');

      String title = titleRegex.firstMatch(output)?.group(1) ?? "Unknown Title";
      String artist =
          artistRegex.firstMatch(output)?.group(1) ?? "Unknown Artist";
      String album = albumRegex.firstMatch(output)?.group(1) ?? "Unknown Album";
      String duration = durationRegex.firstMatch(output)?.group(1) ?? "0:00";

      return {
        'title': title,
        'artist': artist,
        'album': album,
        'duration': duration,
      };
    } catch (e) {
      return {
        'title': 'Unknown Title',
        'artist': 'Unknown Artist',
        'album': 'Unknown Album',
        'duration': '00:00'
      };
    }
  }

  Future<String?> extractAlbumArt(String filePath) async {
    final ffmpegPath = await setupFFmpeg();
    final appDir = await getApplicationSupportDirectory();
    final outputPath =
        '${appDir.path}${Platform.pathSeparator}album${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Run FFmpeg to extract album art
    ProcessResult result = await Process.run(ffmpegPath, [
      '-i', filePath,
      '-an', '-vcodec', 'mjpeg',
      '-filter:v', 'scale=300:-1', // Ensure it resizes correctly
      outputPath
    ]);

    if (result.exitCode == 0 && File(outputPath).existsSync()) {
      return outputPath; // Return path if extraction was successful
    } else {
      Get.log("❌ FFmpeg failed to extract album art: ${result.stderr}");
      return null;
    }
  }

  Future<String> setupFFmpeg() async {
    final appDir = await getApplicationSupportDirectory();
    final ffmpegDir =
        Directory('${appDir.path}${Platform.pathSeparator}ffmpeg');
    final ffmpegPath = '${ffmpegDir.path}${Platform.pathSeparator}ffmpeg.exe';

    // Ensure FFmpeg folder exists
    if (!ffmpegDir.existsSync()) {
      ffmpegDir.createSync(recursive: true);
    }

    // Use absolute path for source file
    final sourcePath = File('ffmpeg/ffmpeg.exe').absolute.path;

    // ✅ Debugging: Print file locations
    print("🔍 Checking FFmpeg source at: $sourcePath");
    print("🔍 Destination path: $ffmpegPath");

    // Ensure source file exists before copying
    if (!File(sourcePath).existsSync()) {
      print("❌ Source FFmpeg file not found at: $sourcePath");
      throw Exception("Source FFmpeg file not found");
    }

    // Copy only if it does not already exist
    if (!File(ffmpegPath).existsSync()) {
      try {
        await File(sourcePath).copy(ffmpegPath);
        print("✅ FFmpeg copied successfully to: $ffmpegPath");
      } catch (e) {
        print("❌ Error copying FFmpeg: $e");
      }
    } else {
      print("⚡ FFmpeg already exists at: $ffmpegPath");
    }

    return ffmpegPath;
  }
}
