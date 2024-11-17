//CURRENTLY NOT CONNECCTED TO ANY PART OF THE APP

class TrackItem {
  final String id;
  final String album;
  final String title;
  final String artist;
  // final String duration; // Changed to String
  final String artUri; // Changed to String

  TrackItem({
    required this.id,
    required this.album,
    required this.title,
    required this.artist,
    // required this.duration,
    required this.artUri,
  });

  factory TrackItem.fromJson(Map<String, dynamic> json) {
    return TrackItem(
      id: json['id'] ?? '',
      album: json['album'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      // duration: json['duration'] ?? '',
      artUri: json['artUri'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'album': album,
      'title': title,
      'artist': artist,
      // 'duration': duration,
      'artUri': artUri,
    };
  }
}
