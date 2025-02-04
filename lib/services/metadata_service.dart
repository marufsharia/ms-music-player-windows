import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';

class MetadataService {
  final Audiotagger _tagger = Audiotagger();

  Future<Tag?> getSongMetadata(String filePath) async {
    try {
      Tag? tag = await _tagger.readTags(path: filePath);
      return tag;
    } catch (e) {
      print("Error fetching metadata: $e");
      return null;
    }
  }
}
