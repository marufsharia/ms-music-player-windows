class Playlist {
  final int? id; // ID for SQLite
  final String name;

  Playlist({this.id, required this.name});

  // Convert from Map (SQLite)
  factory Playlist.fromMap(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
    );
  }

  // Convert to Map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
