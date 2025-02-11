// lib/models/radio_station_model.dart
class RadioStationModel {
  String name;
  String streamUrl;
  String? imageUrl;
  String? genre;
  String? description;

  RadioStationModel({
    required this.name,
    required this.streamUrl,
    this.imageUrl,
    this.genre,
    this.description,
  });

  factory RadioStationModel.fromJson(Map<String, dynamic> json) {
    return RadioStationModel(
      name: json['name'] ?? 'Unknown Station',
      streamUrl: json['streamUrl'] ?? '',
      imageUrl: json['imageUrl'],
      genre: json['genre'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'streamUrl': streamUrl,
      'imageUrl': imageUrl,
      'genre': genre,
      'description': description,
    };
  }
}